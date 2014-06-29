#!/bin/bash

##################################################################
##    DevBoxSetup
##    Zill Christian
##
##    Script automates setup of a LAMP machine fresh from AWS
##    Personalized for Debian
##################################################################

xVersion=1.2.1
xExit=0
xHostname=
xCurrHostname="$(hostname)"
xUsername
xPasswd=

echo "DevBoxSetup $xVersion:\n\n"

# changing into default root
sudo su

# Collect username, passwd, and hostname
echo -ne "Setup Questions:\nUsername for new root user: "
read xUsername
echo "Setup Questions:\nPassword for new root user: "
read -s xPasswd
echo "Setup Questions:\nPreferred Hostname: "
read xHostname

# Update this machine
sudo apt-get update
sudo apt-get upgrade

# Change the hostname
hostname $xHostname
echo "$xHostname" > /etc/hostname
sed -e 's/$xCurrHostname/$xHostname/g' /etc/hosts

# Create the new user
useradd $xUsername -m

sudo apt-get install mysql-server php5-mysql
sudo mysql_install_db
