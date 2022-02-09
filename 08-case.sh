#!/bin/bash

fruit=$1
case $fruit in
 apple) echo Apple Fruit
   ;;
 orange) echo Orange Fruit
   ;;
 *) echo Other Fruit
   ;;
 esac
