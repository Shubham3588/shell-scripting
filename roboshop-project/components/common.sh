LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE  # It will clear the log every time before running.

## BUG about reaching one endpoint , To fix this we are using this command
rm -f /etc/yum.repos.d/endpoint.repo

STAT() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit 1
  fi
}

APP_USER_SETUP_WITH_APP() {

  echo "Create App User"
  id roboshop &>>$LOG_FILE
  if [ $? -ne 0 ]; then
  useradd roboshop &>>$LOG_FILE
  fi
  STAT $?

    echo "Download ${COMPONENT} code"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG_FILE
    STAT $?

    echo "Extract ${COMPONENT} code"
    cd /tmp/
    unzip -o ${COMPONENT}.zip &>>$LOG_FILE
    STAT $?

    echo "clean old ${COMPONENT} CONTENT"
    rm -rf /home/roboshop/${COMPONENT}
    STAT $?

    echo "copy ${COMPONENT} content"
    cp -r ${COMPONENT}-main /home/roboshop/${COMPONENT}
    STAT $?
}

SYSTEMD_SETUP() {
    chown roboshop:roboshop /home/roboshop/ -R &>>$LOG_FILE

    echo "Update ${COMPONENT} systemD file"
    sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/RABBITMQ-IP/rabbitmq.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG_FILE
    STAT $?

    echo "setup ${COMPONENT} SystemD File"
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>$LOG_FILE
    STAT $?

    echo "start ${COMPONENT}"
    systemctl daemon-reload &>>$LOG_FILE
    systemctl enable ${COMPONENT} &>>$LOG_FILE
    systemctl restart ${COMPONENT} &>>$LOG_FILE
    STAT $?
}

NODEJS () {
  COMPONENT=$1
  echo "Setup NodeJs Repo"
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE
  STAT $?

  echo "Install NodeJS"
  yum install nodejs gcc-c++ -y &>>$LOG_FILE
  STAT $?

  APP_USER_SETUP_WITH_APP


  echo "Install NodeJs Dependency"
  cd /home/roboshop/${COMPONENT}
  npm install &>>$LOG_FILE
  STAT $?

  SYSTEMD_SETUP
}

JAVA() {
  COMPONENT=$1
echo "Install Maven"
yum install maven -y &>>$LOG_FILE
STAT $?

APP_USER_SETUP_WITH_APP

echo "Compile ${COMPONENT} code"
cd /home/roboshop/${COMPONENT}
mvn clean package &>>$LOG_FILE
mv target/shipping-1.0.jar shipping.jar
STAT $?

SYSTEMD_SETUP

}

PYTHON() {
  COMPONENT=$1

echo "Install Python"
yum install python36 gcc python3-devel -y &>>$LOG_FILE
STAT $?

APP_USER_SETUP_WITH_APP

echo "Install Python Dependencies for ${COMPONENT}"
cd /home/roboshop/${COMPONENT}
pip3 install -r requirements.txt &>>$LOG_FILE
STAT $?

echo "Update Application Config"
USER_ID=$(id -u roboshop)
GROUP_ID=$(id -g roboshop)
sed -i -e "/uid/ c uid = ${USER_ID}" -e "/gid/ c gid = ${GROUP_ID}" /home/roboshop/${COMPONENT}/${COMPONENT}.ini
STAT $?

SYSTEMD_SETUP

}

GOLANG() {
  COMPONENT=$1

  echo "Install GOLANG"
  yum install golang -y &>>$LOG_FILE
  STAT $?

  APP_USER_SETUP_WITH_APP

  echo "Build Golang code"
  cd /home/roboshop/${COMPONENT}
  go mod init dispatch &>>$LOG_FILE
  go get &>>$LOG_FILE
  go build &>>$LOG_FILE
  STAT $?

  SYSTEMD_SETUP
}