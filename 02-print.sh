#!/bin/bash

echo Hello World, Welcome to DevOps

## When we print some times we print errors and to grab attention of user it is better to print in color

# Syntax : echo -e "\e[COLmMESS\e[0m"
  # -e option to enable esc seq \e
  # \e - to enable color
  # [COLm - COL is color number
  # \e[0m - Disable the color
  # Single quotes or double quotes are mandatory, We prefer to use double quotes all the times

# COL Name      Col Code
# Red           31
# Green         32
# Yellow        33
# Blue          34
# Magenta       35
# Cyan          36

echo -e "\e[31mRED\e[32mGREEN\e[33mYELLOW\e[34mBLUE\e[35mMAGENTA\e[36mCYAN\e[0m"