#!/bin/bash
# Installation proccess for docker and nvidia-docker

docker::__setup_ubuntu_debian()  {
  # Stop docker if running 
  sudo systemctl stop docker 2>/dev/null || :

  # Remove previous versions
  sudo apt-get remove \
      docker \
      docker-engine \
      docker.io \
      containerd \
      runc
  # Prereqs
  sudo apt-get update
  sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common

  # Add GPG key
  curl -fsSL https://download.docker.com/linux/"$1"/gpg | sudo apt-key add -

  # Add APT to sources
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$1 \
    $(lsb_release -cs) \
    stable"
    
  # Install docker
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io
}

docker::__setup_centos() {
  # Remove previous versions
  sudo yum remove \
      docker \
      docker-client \
      docker-client-latest \
      docker-common \
      docker-latest \
      docker-latest-logrotate \
      docker-logrotate \
      docker-engine

  # Prereqs
  sudo yum install -y yum-utils
  sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

  # Install 
  sudo yum install docker-ce docker-ce-cli containerd.io
}

nvidia::__setup() {
  # Fetch GPG key
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  # Install nvidia docker
  sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
  sudo systemctl restart docker
}

distro=$(. /etc/os-release; echo $ID)
case $distro in
  "ubuntu")
  ;&
  "debian")
    docker::__setup_ubuntu_debian "$distro"
  ;;
  "centos")
    docker::__setup_centos
  ;;
esac
nvidia::__setup
