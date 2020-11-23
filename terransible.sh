#!/bin/bash

apt update

apt install -y python-pip unzip

pip install --upgrade pip

echo "--------->>>> Install Terraform <<<<-------------"
curl -O https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
mkdir /bin/terraform
unzip -f terraform_0.12.24_linux_amd64.zip -d /bin/terraform
unzip -f terraform_0.12.24_linux_amd64.zip -d /usr/local/bin
export PATH=$PATH:/bin/terraform
terraform --version
sleep 3

pip install awscli --upgrade
aws --version
sleep 3

apt install -y software-properties-common

echo "-------------------->>>>> Install Ansible Package for Ubuntu <<<<<<--------"
apt install -y ansible
echo "localhost" >> /etc/ansible/hosts
echo "ansible        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers



echo "-------------------->>>>> Ansible Verion <<<<<<-------------------------"
ansible --version

echo "-------------------->>>>> Install Git <<<<<<--------"
apt install -y git
echo "-------------------->>>>> Git Verion <<<<<<-------------------------"
git --version

#bash createuser.sh

apt install -y python-boto python-boto3

echo "----->>>disable host_key_checking in /etc/ansible/ansible.cfg to prevent to first login to aws ec2"
mkdir ~/terransible
sed -i 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg

#echo "---->Set Hostname"
#hostnamectl set-hostname terransible-ubuntu
#exec $SHELL
