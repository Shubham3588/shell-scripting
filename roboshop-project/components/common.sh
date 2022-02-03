LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE  # It will clear the log every time before running.

STAT() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit 1
  fi
}

NODEJS () {
  COMPONENT=$1
  echo "Setup NodeJs Repo"
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE
  STAT $?

  echo "Install NodeJS"
  yum install nodejs gcc-c++ -y &>>$LOG_FILE
  STAT $?

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

  echo "clean old ${COMPONENT}"
  rm -rf /home/roboshop/${COMPONENT}
  STAT $?

  echo "copy ${COMPONENT} content"
  cp -r ${COMPONENT}-main /home/roboshop/${COMPONENT}
  STAT $?
  echo "Install NodeJs Dependency"
  cd /home/roboshop/${COMPONENT}
  npm install &>>$LOG_FILE
  STAT $?

  chown roboshop:roboshop /home/roboshop/ -R &>>$LOG_FILE

  echo "Update ${COMPONENT} systemD file"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG_FILE
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