#!/bin/bash

##################################################################
##    DevBoxSetup
##    Zill Christian
##
##    Script automates setup of a LAMP machine fresh from AWS
##    Personalized for Debian (tested on Ubuntu 12.04)
##
##    To run:
##    1. move file to new instance (scp might be best way)
##    2. chmod +x setup.sh
##    3. sh setup.sh
##################################################################


######## Sys Vars ##########
xVersion=1.2.1
xExit=0
### Do Not Change Above ###


###### Change below to personalize install ######
xCurrHostname="$(hostname)"
xHostname=
xUsername
xPasswd=
xLAMP=1
xDisablePubKeyAuth=1
xIP="$(ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//') | head -1"


xPYTHON=1
xNODEJS=1
xRUBY=1
xVSFTP=1
xNETCAT=1
#################################################



# Init
echo "DevBoxSetup $xVersion:\n\n"

# Changing into default root
sudo su


# Collect username, passwd, and hostname
echo -ne "Setup Questions:\nUsername for new root user: "
read xUsername
echo "Setup Questions:\nPassword for new root user: "
read -s xPasswd
echo "Setup Questions:\nPreferred Hostname: "
read xHostname

# Change the hostname
echo -e "Adding "
hostname $xHostname
echo "$xHostname" > /etc/hostname
sed -e 's/$xCurrHostname/$xHostname/g' /etc/hosts

# Create the new user
useradd $xUsername -m

# Assign user the given password
echo "$xUsername:$xPasswd" | chpasswd

# Add user to sudoers file
echo "$xUsername ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Add user to both sudo & root group ## Put sep lines for handling
usermod -a -G root $xUsername
usermod -a -G sudo $xUsername





# Update this machine
sudo apt-get update
sudo apt-get upgrade

# Apache2, MySQL, PHP5, connectors
if [ "$xLAMP" -ne "1" ]
then
  sudo apt-get install apache2
  sudo apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql
fi

sudo apt-get install mysql-server php5-mysql
sudo mysql_install_db
