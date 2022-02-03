#The frontend is the service in RobotShop to serve the web content over Nginx.
source components/common.sh #calling the common log file for reusing
echo "Installing Nginx"
yum install nginxx -y &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo -e "\e[1;32m Success\e[0m"
  else
  echo -e "\e[1;33m Failed\e[0m"
exit
fi
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