#!/bin/bash
sudo yum -y update
sudo yum -y install ruby
sudo yum -y install wget
sudo yum -y install httpd

cd /home/ec2-user
wget https://aws-codedeploy-${AWS_REGION}.s3.${AWS_REGION}.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

sudo yum install -y python-pip
sudo pip install awscli

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Create web directory
sudo mkdir -p /var/www/html
#make scripts executable 
chmod +x scripts/*.sh