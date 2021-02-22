#!/bin/bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
wget https://archives.fedoraproject.org/pub/archive/epel/5/x86_64/epel-release-5-4.noarch.rpm
sudo rpm -i epel-release-5-4.noarch.rpm
sudo yum -y install python3-pip
sudo yum -y install python3
pip3 install pip --upgrade
sudo pip3 install boto3
sudo pip3 install ansible 
sudo pip3 install awscli
sudo ansible-galaxy collection install community.general
sudo ansible-galaxy collection install amazon.aws