#The frontend is the service in RobotShop to serve the web content over Nginx.
LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE  # It will clear the log every time before running.
echo "Installing Nginx"
yum install nginx -y &>>$LOG_FILE

echo "Download Frontend Content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE

echo "Clean Old Content"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE

echo "Extract Frontend Content"
cd /tmp &>>$LOG_FILE
unzip -o /tmp/frontend.zip &>>$LOG_FILE

echo "Copy extracted content to Nginx Path"
cp -r frontend-main/static/* /usr/share/nginx/html/ &>>$LOG_FILE

echo "Copy Nginx Roboshop Config"
cp frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE

echo "Start Nginx Service"
systemctl enable nginx &>>$LOG_FILE
systemctl start nginx &>>$LOG_FILE