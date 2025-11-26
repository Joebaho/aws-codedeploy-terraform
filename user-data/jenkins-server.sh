#!/bin/bash
sudo yum -y update
sudo yum -y install git

#install terraform
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform -v

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install jenkins java-17-amazon-corretto-devel -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Wait for Jenkins to start
sleep 30

# Install AWS CodeDeploy plugin (this would typically be done via Jenkins UI)
echo "Jenkins installation completed. Please complete setup via web UI."
echo "Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword