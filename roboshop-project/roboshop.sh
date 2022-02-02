#!/bin/bash

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo -e "\e[1;31m You should be root user to execute this script...\e[0m"
  exit
  fi

bash components/$1.sh