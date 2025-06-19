#!/bin/bash

read -p "enter your name:" user_input

read -p "enter your assignment name:" user_assignment 

path="./submission_reminder_$user_input"

sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$user_assignment\"/" "$path/config/config.env"

bash "$path/startup.sh"

