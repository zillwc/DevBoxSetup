DevBoxSetup
=============

Quick setup of a dev stack (lamp) on a fresh instance from AWS
Personalized for Debian (tested on Ubuntu 12.04)

Created primarily for personal use with aws api - auto deploy for load/stress testing for mtrkv3

To run:
1. move file to new server (scp might be best way)
2. sudo chmod +x setup.sh
3. sh setup.sh

Script has options to install and properly setup the following:
- Apache2
- MySQL-Server
- PHP5
- Perl
- Python
- Ruby
- Nodejs

- RVM
- NPM
- Netcat
- Htop
- FTP/SFTP pasv mode
- SSH with PubKeyAuth Disabled
- Machine Hostname
- php-mcrypt
- php-curl
- php-cli
- php-imap

- sys updates duh

Script does all the above by default but totally configurable through script or cli switches

Zill Christian
