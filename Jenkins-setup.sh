#!/bin/bash
yum install java-11-openjdk -y
curl -L -o /etc/yum.repos.d/jenkins.repo  https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install  epel-release -y
yum install jenkins -y
systemctl enable jenkins
systemctl start jenkins
