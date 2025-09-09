#!/bin/bash
#
help() {
        echo "Default installs docker, kubectl, helm, & k9s"
        echo "Choose one of k0s, minikube, docker, kubectl, helm, k9s t install the individual application"
        echo "Choose k0sp or minikubep to include the supporting tools"
	exit
}
docker() {
	# removes existing docker install before installing directly from docker repositories.
	for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

	# Set up Docker's apt repository 
	# Add Docker's official GPG key:
	sudo apt-get update
	sudo apt-get install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update

	#install
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
	sudo usermod -aG docker jimmy
	# End Script
	# ----------------------------
}
kubectl() {
	#install kubectl
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	sudo install kubectl /usr/local/bin/
	rm ./kubectl
}
helm() {
	#install helm
	curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}
k9s() {
	#install k9s (not required but useful kubernetes managment tool)
	curl -LO https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz
	tar -zxf k9s_Linux_amd64.tar.gz k9s
	sudo install k9s /usr/local/bin/
	rm k9s*
}
k0s() {
	#install k0s quickly sets up a local Kubernetes cluster.
	curl -sSLf https://get.k0s.sh | sudo sh
}
k3d() {
	#install k3d quickly set up a multi cluster enviroment in docker.
	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
}
k0sp() {
	#install k0s quickly sets up a local Kubernetes cluster.
 	#also calls main to install docker, kubectl, helm, k9s.
	curl -sSLf https://get.k0s.sh | sudo sh
	main
}
minikube() {
  # minikube quickly sets up a local Kubernetes cluster 
  curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
}
minikubep() {
  # minikube quickly sets up a local Kubernetes cluster.
  #also calls main to install docker, kubectl, helm, k9s.
  curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
  main
}
main() {
	docker
	kubectl
	helm
	k9s
}

# verify options
function_exists() {
    declare -F "$argv" > /dev/null
    return $?
} 


argv=$1
if [ -z $argv ]; then
	main
elif [ $argv ]; then
	if function_exists "$argv"; then
		$argv
	else
		echo invalid argument: $argv
		help
	fi
else
    echo "Invalid choice [${argv}]..."
fi
