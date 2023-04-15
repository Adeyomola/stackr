#! /bin/bash

# install ansible

function ansible() {
if [[ $( ansible --version >> /dev/null 2>&1 )$? -eq 0 ]]
then
echo "ansible is already installed"

elif [[ $( python3 -m pip -V >> /dev/null 2>&1 )$? -ne 0 &&  $( ansible --version >> /dev/null 2>&1 )$? -ne 0 ]]
then
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
python3 -m pip install --user ansible

fi
}

# install aws-cli

function aws-cli() {
if [[ $(aws --version >> /dev/null 2>&1)$? -eq 0 ]]
then
echo "aws-cli is already installed"

else
sudo apt update -y
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

fi
}

# install docker

function docker() {
if [[ $(docker -v >> /dev/null 2>&1)$? -eq 0 ]]
then
echo "docker is already installed"

else
sudo apt-get remove docker docker-engine docker.io containerd runc -y
sudo apt-get update -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

fi
}

#install kubectl

function kubectl() {
if [[ $(kubectl version --client >> /dev/null 2>&1)$? -eq 0 ]]
then
echo "kubectl is already installed"

else
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

fi
}

#install minkube

function minikube() {
if [[ $(minikube version >> /dev/null 2>&1)$? -eq 0 ]]
then
echo "minikube is already installed"

else
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

fi
}

function terraform() {
if [[ $(terraform --version >> /dev/null 2>&1)$? -eq 0 ]]
then
echo "terraform is already installed"

else
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common gpg
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform

fi
}

#case switch
case $1 in
"ansible")
ansible;;
"terraform")
terraform;;
"docker")
docker;;
"aws-cli")
aws-cli;;
"kubectl")
kubectl;;
"minikube")
minikube;;
esac
