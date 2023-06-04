#!/bin/bash

start_jenkins(){
  echo "ENABLING JENKINS"
  systemctl enable jenkins
  export isRunning='ps -ef|grep jenkins|grep -v grep | wc -l'
  if [[ $isRunning -eq 0 ]];
  then
    echo "STARTING JENKINS"
    systemctl start jenkins
    echo "JENKINS STARTED"
    echo "First Time login pasword: "
    echo 
    echo ${cat /var/lib/jenkins/secrets/initialAdminPassword}
    echo
  else
    echo "JENKINS RUNNING"
    echo "First Time login pasword: "
    echo 
    echo ${cat /var/lib/jenkins/secrets/initialAdminPassword}
    echo
  fi
}

create_repo() {
  if [[ $install_code -eq 1 ]];
  then
    echo "IMPORTING PUBLIC KEY"
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    echo "CREATING REPO"
    curl -L -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  elif [[ $install_code -eq 2 ]];
  then
    #downloding the key
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
      /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    
    #creating the repo
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
  fi
}

install(){
    if [[ $install_code -eq 1 ]];
    then
        echo "CHECKING WHETHER JENKINS REPO IS AVAILABLE"
        if [ -f /etc/yum.repos.d/jenkins.repo ]; 
        then
            echo "JENKINS REPO IS AVAILABLE"
            echo "INSTALLING"
            yum install -y epel-release jenkins > /dev/null
            start_jenkins
        else
            create_repo
            echo "INSTALLING JENKINS"
            yum install -y epel-release jenkins > /dev/null
            start_jenkins
        fi
        
    elif [[ $install_code -eq 2 ]];
    then
        if [[ -f /usr/share/keyrings/jenkins-keyring.asc && -f /etc/apt/sources.list.d/jenkins.list ]];
        then
        echo "INSTALLING JENKINS"
        apt-get update && apt install jenkins -y > /dev/null
        start_jenkins
        else
        create_repo
        echo "INSTALLING JENKINS"
        apt-get update && apt install jenkins -y > /dev/null
        start_jenkins
        fi 
    fi

}
java_installation(){
    if [[ $install_code -eq 1 ]];
    then
        echo "INSTALLING JAVA"
        yum install java-11* -y
    elif [[ $install_code -eq 2 ]];
    then
        echo "INSTALLING JAVA"
        apt-get update && apt install openjdk-11-jdk -y > /dev/null
    fi
}

jenkinsInstallation(){
  #Checking Java installed or not
  which java > /dev/null 2>&1
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
    java_installation
    install
  fi
}

#Checking OS-family
OS_FAMILY=$(grep -w 'NAME' /etc/os-release | awk -F"=" '{print $2}' | awk '{print $1}' | sed 's/"//g')

#converting to lowercase
os_family=${OS_FAMILY,,}

case $os_family in
  centos|redhat|fedora)
    export install_code=1
    jenkinsInstallation
    #rpm_based_installation
    ;;
  ubuntu|debian)
    export install_code=2
    jenkinsInstallation
    #debian_based_installation
    ;;
  *)
    echo "Unkown linux distribution"
    ;;
esac
