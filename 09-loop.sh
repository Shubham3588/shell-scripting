#!/bin/bash

# for

for fruit in apple banana ; do
  echo $fruit
done

#For loop is going to iterate number of times is based on number of inputs

#while
i=10
while [ $i -gt 0 ]; do
  echo Iteration - $i
  i=$(($i-1))
done