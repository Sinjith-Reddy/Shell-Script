#!/bin/bash

create_repo() {
  echo "CREATING REPO"
  curl -L -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  echo "IMPORTING PUBLIC KEY"
  rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
}

install_start() {
  echo "INSTALLING EPEL-RELEASE"
  yum install  epel-release -y
  echo "INSTALLING JENKINS"
  yum install jenkins -y
  echo "ENABLING JENKINS"
  systemctl enable jenkins
  echo "STARTING JENKINS"
  systemctl start jenkins
}

install() {
    echo "CHECKING WHETHER JENKINS REPO IS AVAILABLE"
    if [ -f /etc/yum.repos.d/jenkins.repo ]; 
    then
      echo "JENKINS REPO IS AVAILABLE"
      install_start
    else
      create_repo
      install_start
    fi
  }

#Checking Java installed or not
which java >/dev/null 2>&1
if [[ $? -eq 0 ]]; 
then
  echo "JAVA IS INSTALLED"
  echo "CHECK VERSION OF JAVA"
  JAVA_VERSION=$(java --version | awk 'NR==1{printf("%.0f",$2)}')
  if [[  ${JAVA_VERSION} -ge 11 ]]; 
  then
    echo "MINIMUM REQUIRED VERSION JAVA ${JAVA_VERSION} IS INSTALLED"
    echo "PROCEEDING TO INSTALL JENKINS"
    install
  else
    echo "REQUIRED JAVA VERSION IS NOT INSTALLED"
  fi
else 
  echo "JAVA IS NOT INSTALLED, WILL SETUP"
  yum install java-11* -y
  install
fi