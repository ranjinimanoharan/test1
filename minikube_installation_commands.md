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

Become a root user:

sudo -i
start Minikube
minikube start --vm-driver=none
apt install conntrack
minikube status
