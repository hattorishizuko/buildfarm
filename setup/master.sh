#!/bin/bash

sudo apt-get -y install openjdk-7-jdk

sudo apt-get -y install git
git config --global user.email "jenkinshrg@gmail.com"
git config --global user.name "jenkinshrg"
git config --global credential.helper store
git config --global http.sslVerify false

wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get -y install jenkins
sleep 30

sudo sh -c 'echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'

cat << EOL | sudo tee /var/lib/jenkins/config.xml
<?xml version='1.0' encoding='UTF-8'?>
<hudson>
  <numExecutors>0</numExecutors>
  <slaveAgentPort>9000</slaveAgentPort>
</hudson>
EOL

# cat << EOL | sudo tee -a /var/cache/jenkins/war/css/style.css
# pre {
#     background-color: #2a2a2a;
#     color: #f1f1f1;
# }
# EOL

wget -q http://localhost:8080/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin git
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin multiple-scms
# java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin clone-workspace-scm
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin embeddable-build-status
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin timestamper
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin ansicolor 
# java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin parameterized-trigger
# java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin cmakebuilder
# java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin warnings
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin cobertura
# java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin cccc
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin cppcheck
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin valgrind
# java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin htmlpublisher
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin xunit
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin plot
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin email-ext
# java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin join
rm jenkins-cli.jar

sudo service jenkins restart
sleep 30
