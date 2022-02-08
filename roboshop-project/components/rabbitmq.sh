
#1. Start RabbitMQ
#
#```sql
## systemctl enable rabbitmq-server
## systemctl start rabbitmq-server
#```
#
#RabbitMQ comes with a default username / password as `guest`/`guest`. But this user cannot be used to connect. Hence we need to create one user for the application.
#
#1. Create application user
#
#```sql
## rabbitmqctl add_user roboshop roboshop123
## rabbitmqctl set_user_tags roboshop administrator
## rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
#```
#
#Ref link : [https://www.rabbitmq.com/rabbitmqctl.8.html#User_Management](https://www.rabbitmq.com/rabbitmqctl.8.html#User_Management)

source components/common.sh

echo "Configure YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG_FILE
STAT $?

echo "Install RabbitMQ and ErLang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>$LOG_FILE
STAT $?

echo "Start RabbitMQ Server"
systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl start rabbitmq-server  &>>$LOG_FILE
STAT $?

echo "Create Application User"
rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE