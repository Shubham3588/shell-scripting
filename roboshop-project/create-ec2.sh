#!/bin/bash

INSTANCE_NAME=$1
if [ -z "${Instance_Name}" ]; then
  echo -e "\e[1;33mInstance Name Argument is needed\e[0m"
  exit
  fi
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" --query 'Images[*].[ImageId]' --output text)

if [ -z "${AMI_ID}" ]; then
  echo "Unable to find image AMId"
else
  echo AMI ID = ${AMI_ID}
fi



aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.micro