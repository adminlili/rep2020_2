#!/bin/sh
echo -n "Enter the username: "
read username
echo -n "Enter the password: "
read -s password
adduser "$username"
# read -s is for the password won't be displayed while typing
echo "\n\t User $username and password for this user successfully created!!\n"
