#!/bin/bash
echo "------------------Instaling Java------------------"
yum install java-11* -y
echo "------------------creating repo------------------"
touch /etc/yum.repos.d/jenkins.repo
echo "[jenkins] \
name=Jenkins-stable \
baseurl=http://pkg.jenkins.io/redhat-stable \
gpgcheck=1" > /etc/yum.repos.d/jenkins.repo
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
