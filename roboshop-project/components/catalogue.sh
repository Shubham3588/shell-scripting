source components/common.sh

echo "Setup NodeJs Repo"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE
STAT $?

echo "Install NodeJS"
yum install nodejs gcc-c++ -y &>>$LOG_FILE
STAT $?

echo "Create User"
useradd roboshop &>>$LOG_FILE
STAT $?

echo "Download Catalogue code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
STAT $?

echo "Extract Catalogue code"
cd /tmp/
unzip -o catalogue.zip &>>$LOG_FILE
STAT $?

echo "clean old Catalogue"
rm -rf /home/roboshop/catalogue
STAT $?

echo "copy catalogue content"
cp -r catalogue-main /home/roboshop/catalogue
STAT $?
echo "Install NodeJs Dependency"
cd /home/roboshop/catalogue
npm install &>>$LOG_FILE
STAT $?

chown roboshop:roboshop /home/roboshop/ -R &>>$LOG_FILE

echo "Update systemD file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>$LOG_FILE
STAT $?

echo "setup catalogue SystemD File"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
STAT $?

echo "start catalogue"
systemctl daemon-reload &>>$LOG_FILE
systemctl enable catalogue &>>$LOG_FILE
systemctl start catalogue &>>$LOG_FILE
STAT $?
