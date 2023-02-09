#!/bin/bash
sudo su
apt update -y
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1>Hello from Ibraim here $myip </h1>" > /var/www/html/index.html
