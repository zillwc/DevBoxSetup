#!/bin/bash

##################################################################
##    DevBoxSetup
##    Zill Christian
##
##    Script automates setup of a LAMP machine fresh from AWS
##    Personalized for Debian (tested on Ubuntu 12.04)
##
##    To run:
##    1. move file to new server (scp might be best way)
##    2. chmod +x setup.sh
##    3. sh setup.sh
##################################################################


######## Sys Vars ##########
xVersion=1.2.1
xExit=0
xCurrHostname="$(hostname)"
########----------##########




############### PERSONALIZATION #################

xHostname=
xUsername=
xPasswd=
xDisablePubKeyAuth=1

xPERL=1
xPYTHON=1
xNODEJS=1
xRUBY=1
xVSFTPD=1
xNETCAT=1
################--------------####################




################### INIT #####################
# Init
echo -e "DevBoxSetup $xVersion:\n\n"
##############-----------------###############




############## COLLECTING DATA ###############

# Collect username, passwd, and hostname
echo -e "Setup Questions:\nUsername for new root user: "
read xUsername
echo -e "Password for new root user: "
read -s xPasswd
echo -e "Setup Questions:\nPreferred Hostname: "
read xHostname
##############-----------------###############




################### SETTING UP USER #####################

# Change the hostname
echo -e "Adding "
hostname $xHostname
echo "$xHostname" > /etc/hostname
sed -e 's/$xCurrHostname/$xHostname/g' /etc/hosts
echo "127.0.1.1  $xHostname" >> /etc/hosts

# Create the new user
useradd $xUsername -m

# Assign user the given password
echo "$xUsername:$xPasswd" | chpasswd

# Add user to sudoers file
echo "$xUsername ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Add user to both sudo & root group
## Put in separate lines for better handling
usermod -a -G root $xUsername
usermod -a -G sudo $xUsername
##############-----------------###############




########## INSTALLING PACKAGES #############

# Update this machine
echo -e "----Updating machine"
sleep 2
sudo apt-get update
sudo apt-get upgrade

# Apache2, MySQL, PHP5, XLibs
echo -e "----Installing LAMP Core Apps"
sleep 2
sudo apt-get install apache2
sudo apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql
sudo mysql_install_db
sudo apt-get install php5 libapache2-mod-php5 php5-mcrypt php5-curl php5-cli

# Perl install
if [ "$xPERL" = "1" ]
then
  echo -e "----Installing Perl"
  sleep 2
  sudo apt-get install perl
fi

# Python install
if [ "$xPYTHON" = "1" ]
then
  echo -e "----Installing Python"
  sleep 2
  sudo apt-get install python
fi

# NodeJS install
if [ "$xNODEJS" = "1" ]
then
  echo -e "----Installing and setting up Nodejs"
  sleep 2
  sudo apt-get install nodejs
  sudo apt-get install npm
fi

# Ruby install
if [ "$xRUBY" = "1" ]
then
  echo -e "----Installing Ruby"
  sleep 2
  sudo apt-get install ruby
fi

# vsFTPd install
if [ "$xVSFTPD" = "1" ]
then
  echo -e "----Installing and setting up VSFTPD"
  sleep 2
  sudo apt-get install vsftpd
  sed -i.bak -e 's/anonymous_enable=NO/anonymous_enable=YES/g' /etc/vsftpd.conf
  sed -e 's/#local_enable=YES/local_enable=YES/g' /etc/vsftpd.conf
  sed -e 's/#write_enable=YES/write_enable=YES/g' /etc/vsftpd.conf
  sed -e 's/#chroot_local_user=YES/chroot_local_user=YES/g' /etc/vsftpd.conf
fi

# Netcat install
if [ "$xNETCAT" = "1" ]
then
  echo -e "----Installing Netcat"
  sleep 2
  sudo apt-get install netcat
fi
################# -------------------- ###################





########## DISABLE PUB KEY AUTH #############
if [ "$xDisablePubKeyAuth" = "1" ]
then
  echo -e "----Public key authentication disabling"
  sleep 2
  sed -i.bak -e 's/PubkeyAuthentication yes/PubkeyAuthentication no/g' /etc/ssh/sshd_config
  sed -i.bak -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
fi
###############------------##################





############ RESTART SERVICES ###############
echo -e "----Restarting all services"
sudo service apache2 restart
sudo service vsftpd restart
sudo service ssh restart
###############------------##################




############## UPDATE AGAIN ################
echo -e "----Updating machine again"
sleep 2
sudo apt-get update
sudo apt-get upgrade
echo -e "\n--Script has finished installing\n"
sleep 2
###############------------##################
