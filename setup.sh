#!/bin/bash

#####################################################################
##    DevBoxSetup
##    Zill Christian
##
##    Script automates setup of a LAMP stack for a fresh AWS instance
##    Personalized for Debian (tested on Ubuntu 12.04)
##
##    To run:
##    1. deploy file to new server (scp might be best way)
##    2. sudo chmod +x setup.sh
##    3. sh setup.sh
#####################################################################



######## Sys Vars ##########
xVersion=1.2.1
xExit=0
xCurrHostname="$(hostname)"
########----------##########



################# Usage display ##################
usage()
{
	clear
	echo -e "DevBoxSetup\nQuick setup of fresh aws instances"
	echo -e "Usage:\n\tdevboxsetup.sh [-r ]\n"
	echo -e "OPTIONS:\n\t-r\tRemove package\n\t-l\tList all packages\n"
	echo -e "EXAMPLES:\n\tdevboxsetup.sh\n\tDefault: installs all the packages"
	echo -e "EXAMPLES:\n\tdevboxsetup.sh -l\n\tList all the available packages"
	echo -e "EXAMPLES:\n\tdevboxsetup.sh -r python\n\tRemoves python from the install packages"
}
################---------------###################




########### Collect Options #########
while getopts “lr:” OPTION
do
     case $OPTION in
         l)
             xLIST=1
             ;;
         d)
             xDISABLED=$OPTARG
             ;;
         ?)
			usage
			xExit=1
             ;;
     esac
done
##########----------------###########



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

# Collect Username
if [ -z "$xUsername" ];
then
  echo -e "Username for new user: "
  read xUsername
fi

# Collect Password
if [ -z "$xPasswd" ];
then
  echo -e "Password for new user: "
  read -s xPasswd
fi

# Collect Hostname
if [ -z "$xHostname" ];
then
  echo -e "\nPreferred Hostname: "
  read xHostname
fi
##############-----------------###############




################### SETTING UP USER #####################

# Change the hostname
echo -e "Adding "
hostname $xHostname
echo "$xHostname" > /etc/hostname
sed -e 's/$xCurrHostname/$xHostname/g' /etc/hosts
echo "127.0.1.1  $xHostname" >> /etc/hosts

# Create the new user
useradd $xUsername -m -s /bin/bash

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
sudo apt-get -y update
sudo apt-get -y upgrade

# Apache2, MySQL, PHP5, XLibs
echo -e "----Installing LAMP Core Apps"
sleep 2
sudo apt-get -y install apache2
sudo apt-get -y install mysql-server libapache2-mod-auth-mysql php5-mysql
sudo mysql_install_db
sudo apt-get -y install php5 libapache2-mod-php5 php5-mcrypt php5-curl php5-cli

# Perl install
if [ "$xPERL" = "1" ]
then
  echo -e "----Installing Perl"
  sleep 2
  sudo apt-get -y install perl
fi

# Python install
if [ "$xPYTHON" = "1" ]
then
  echo -e "----Installing Python"
  sleep 2
  sudo apt-get -y install python
fi

# NodeJS install
if [ "$xNODEJS" = "1" ]
then
  echo -e "----Installing and setting up Nodejs"
  sleep 2
  sudo apt-get -y install nodejs
  sudo apt-get -y install npm
fi

# Ruby install
if [ "$xRUBY" = "1" ]
then
  echo -e "----Installing Ruby"
  sleep 2
  sudo apt-get -y install ruby
fi

# vsFTPd install
if [ "$xVSFTPD" = "1" ]
then
  echo -e "----Installing and setting up VSFTPD"
  sleep 2
  sudo apt-get -y install vsftpd
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
  sudo apt-get -y install netcat
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
sudo apt-get -y update
sudo apt-get -y upgrade
echo -e "\n--Script has finished installing/setting up all packages\n"
sleep 2
###############------------##################

exit 0
