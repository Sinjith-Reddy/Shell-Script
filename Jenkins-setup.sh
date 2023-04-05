#!/bin/bash
echo "------------------Instaling Java------------------"
//java-11 or above s required
yum install java-11-openjdk -y
echo "------------------creating repo------------------"
curl -L -o /etc/yum.repos.d/jenkins.repo  https://pkg.jenkins.io/redhat-stable/jenkins.repo
echo "------------------Importing Key------------------"
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
echo "------------------instaling epel------------------"
yum install  epel-release -y
echo " ------------------Installing Jenkins----------------------"
yum install jenkins -y
echo "------------------Checking Jenkins Status------------------"
systemctl status jenkins
echo "------------------Enabling Jenkins------------------"
systemctl enable jenkins
echo "------------------Starting Jenkins------------------"
systemctl start jenkins
echo "------------------Checking Jenkins Status------------------"
systemctl status jenkins
echo "---------------- Initial Admin Pasowrd is ----------------- "
cat /var/lib/jenkins/secrets/initialAdminPassword
