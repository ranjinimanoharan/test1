**Minikube Prerequisite**

- 2 CPUs or more
- 2GB of free memory
- 20GB of free disk space
- Internet connection
- Container or virtual machine manager, such as: Docker, Hyperkit, Hyper-V, KVM, Parallels, Podman, VirtualBox, or VMWare

**Install kubectl**

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

**Install Docker**

sudo apt-get update

sudo apt-get install docker.io -y

**Install Minikube**

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

**Check Minikube Version**

minikube version

We have now successfully installed Minikube!

**Become a root user:**

sudo -i

**start Minikube**

apt install conntrack

Note: kubernetes 1.20.0 and above need conntrack installed

minikube start --vm-driver=none

**check status**

minikube status
