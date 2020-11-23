!#/bin/bash

sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
sudo systemctl enable docker
sudo usermod -aG docker ${USER}
su - ${USER}
id -nG
sudo usermod -aG docker username
docker run hello-world
