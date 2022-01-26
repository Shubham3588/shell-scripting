#!/bin/bash

### String expressions
a=abc
if [ $a = "abc" ]
then
  echo OK
fi

if [ $a != "1" ]; then
  echo NOT OK
  fi

if [ -z "$b" ]; then
  echo B is empty / not declared
  fi