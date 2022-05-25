#! /bin/bash

# Variable Declaration

# KUBERNETES_VERSION="1.20.6-00"
KUBERNETES_VERSION="1.23.6-00"

# disable swap 
sudo swapoff -a
# keeps the swaf off during reboot
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo apt-get update -y
sudo apt-get install -y \
    ansible \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    bash-completion

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Following configurations are recomended in the kubenetes documentation for Docker runtime. Please refer https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "Docker Runtime Configured Successfully"


sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y

sudo apt-get install -y kubelet=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION kubeadm=$KUBERNETES_VERSION

sudo apt-mark hold kubelet kubeadm kubectl
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
. /etc/bash_completion
echo ". /etc/bash_completion" >> ~/.bashrc
echo "alias k=kubectl" >> ~/.bashrc
echo "complete -F __start_kubectl k" >> ~/.bashrc
echo "alias kaf='kubectl apply -f'" >> ~/.bashrc
echo "alias kgp='kubectl get pod'" >> ~/.bashrc
echo "alias kgd='kubectl get deploy'" >> ~/.bashrc
echo "alias kga='kubectl get pod,svc,ep,cm,secret,pv,pvc,sc --show-labels'" >> ~/.bashrc
echo "alias kgn='kubectl get ns -A'" >> ~/.bashrc
echo "alias kdp='kubectl describe pod'" >> ~/.bashrc
echo "alias kdd='kubectl describe deploy'" >> ~/.bashrc
echo "alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'" >> ~/.bashrc
echo "alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'" >> ~/.bashrc
echo "autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab number relativenumber paste autoindent smartindent" >> ~/.vimrc
