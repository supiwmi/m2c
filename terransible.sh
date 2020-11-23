#!/bin/bash

sudo apt update

sudo apt install -y python-pip unzip

sudo pip install --upgrade pip

echo "--------->>>> Install Terraform <<<<-------------"
sudo curl -O https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
sudo mkdir /bin/terraform
sudo unzip -f terraform_0.12.24_linux_amd64.zip -d /bin/terraform
sudo unzip -f terraform_0.12.24_linux_amd64.zip -d /usr/local/bin
sudo export PATH=$PATH:/bin/terraform
terraform --version
sleep 3

pip install awscli --upgrade
aws --version
sleep 3

sudo apt install -y software-properties-common

echo "-------------------->>>>> Install Ansible Package for Ubuntu <<<<<<--------"
sudo apt install -y ansible
sudo echo "localhost" >> /etc/ansible/hosts
sudo echo "ansible        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers



echo "-------------------->>>>> Ansible Verion <<<<<<-------------------------"
sudo ansible --version

echo "-------------------->>>>> Install Git <<<<<<--------"
sudo apt install -y git
echo "-------------------->>>>> Git Verion <<<<<<-------------------------"
git --version

#bash createuser.sh

sudo apt install -y python-boto python-boto3

echo "----->>>disable host_key_checking in /etc/ansible/ansible.cfg to prevent to first login to aws ec2"
mkdir ~/terransible
sudo sed -i 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg

#echo "---->Set Hostname"
#hostnamectl set-hostname terransible-ubuntu
#exec $SHELL
