#!/bin/bash

student_name="Raju"

echo student_name = $student_name
echo student_name = ${student_name}

DATE=2021-01-2026
echo Good Morning, Today date is $DATE

## command substitution

DATE=$(date +%F)
echo Good Morning, Today date is $DATE

##Arithmetic Substitution
EXPR1=$((2+3-4/7*8))
echo EXPR1 OUTPUT = $EXPR1

## TRYING TO ACCESS A VARIABLE FROM SHELL COMMAND LINE (E.G: wE ARE ASSIGNING SOME VALUES in server side at run time, So by using export command we can use that value.)
echo course_name = $COURSE_NAME