#The frontend is the service in RobotShop to serve the web content over Nginx.
source components/common.sh #calling the common log file for reusing

echo "Installing Nginx"
yum install nginx -y &>>$LOG_FILE
STAT $?

echo "Download Frontend Content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
STAT $?

echo "Clean Old Content"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
STAT $?

echo "Extract Frontend Content"
cd /tmp &>>$LOG_FILE
unzip -o /tmp/frontend.zip &>>$LOG_FILE
STAT $?

echo "Copy extracted content to Nginx Path"
cp -r frontend-main/static/* /usr/share/nginx/html/ &>>$LOG_FILE
STAT $?

echo "Copy Nginx Roboshop Config"
cp frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
STAT $?

echo "Update RoboShop Config"
sed -i -e "/catalogue/ s/localhost/catalogue.roboshop.internal/" -e '/user/ s/localhost/user.roboshop.internal/' -e 's/cart/ s/localhost/cart.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
STAT $?

echo "Start Nginx Service"
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
STAT $?