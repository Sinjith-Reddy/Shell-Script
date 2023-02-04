#!/bin/bash
echo "------------------Instaling Java------------------"
sudo yum install java-11* -y
echo "------------------creating repo------------------"
sudo touch /etc/yum.repos.d/jenkins.repos
echo "[jenkins]
name=Jenkins-stable
baseurl=http://pkg.jenkins.io/redhat-stable
gpgcheck=1" > /etc/yum.repos.d/jenkins.repo
echo "------------------Importing Key------------------"
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
echo "------------------instaling epel------------------"
sudo yum install  epel-release -y
echo " ------------------Installing Jenkins----------------------"
sudo yum install jenkins -y
echo "------------------Checking Jenkins Status------------------"
sudo systemctl status jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins