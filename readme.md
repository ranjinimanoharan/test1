## Task1
## Task details
- Based on Minikube
- Deploy tomcat v8 to minikube
- Deploy sample.war to tomcat (use this: https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/ )
- Bind tomcat service to hostport 8090

**Create Docker image**
First we need to a docker image using the sample.war file provided in the assignment:
https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/
**Dockerfile**
```
FROM tomcat:8.0-alpine
LABEL maintainer=”deepak@softwareyoga.com”
ADD sample.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD [“catalina.sh”, “run”]
```
For building docker image:
```
docker build -t ranjinimanoharan\assignment:app1
```
Once docker image is built, push it to docker hub registry:

```
docker login #To login to the docker hub
docker push ranjinimanoharan/assignment:app1
```
Now, docker image is ready for our sample app deployment. 

# Create kubernets deployment
Before proceeding with Kubernetes deployment, make sure you have `minikube` and `kubectl` running in the VM.
```
minikube status
kubectl config-view
```
minikube runs a single-node Kubernetes cluster on your personal computer (including Windows, macOS and Linux PCs) and VMs. It is suitable only for development and testing purpose.
*Kubernetes deployment file*
**tomcatdeployment.yaml**
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: tomcat
  name: tomcat
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tomcat
  template:
    metadata:
      labels:
        app: tomcat
    spec:
      containers:
      - image: ranjinimanoharan/assignment:app1
        name: tomcat
        ports:
        - containerPort: 8080
          hostPort: 8090
          name: tomcat
```
Here, `hostport` is used to expose the container to the outside world. `hostport`  exposes the container to the external network at <hostIP>:<hostPort>, where the hostIP is the IP address of the Kubernetes node where the container is running and the hostPort is the port requested by the user. 

To create kubernetes deployment:
```
Kubectl apply -f tomcatdeployment.yaml
```
To check the deployment status:
```
kubectl get deployment
```

