## Task details
- Based on Minikube
- Deploy tomcat v8 to minikube
- Deploy sample.war to tomcat (use this: https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/ )
- Bind tomcat service to hostport 8090
- Deploy nginx/apache to minikube
- Bind nginx/apache to hostport 8080
- Include simple "hello world" in index.html of nginx

**Create Docker image**

First we need to a docker image using the sample.war file provided here:
https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/

**Dockerfile**
```
FROM tomcat:jdk8-openjdk-slim-buster
LABEL maintainer="chinmayaranju@gmail.com"
ADD sample.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD [“catalina.sh”, “run”]
```
For building docker image:
```
docker build -t ranjinimanoharan\assignment:app1 .
```
Once docker image is built, push it to docker hub registry:

```
docker login #To login to the docker hub, provide username & password when prompted 
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
Here, `hostport` is used to expose the container to the outside world. `hostport`  exposes the container to the external network at *hostIP:hostPort*, where the `hostIP` is the IP address of the Kubernetes node where the container is running and the `hostPort` is the port requested by the user. 

To create kubernetes deployment:
```
Kubectl apply -f tomcatdeployment.yaml
```
To check the deployment status:
```
kubectl get deployment
```

Now, lets move on to deploy a nginx to minikube and serve static content like a simple `helloworld!`.

**nginxdeployment.yaml**
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx:latest
        name: nginx
        ports:
        - containerPort: 80
          hostPort: 8080
          name: nginx
```

Now, we have the nginx server up and running inside a container. Here, `hostport` is used to expose the container to the outside world. 

Create kubernetes deployment using:
```
Kubectl apply -f tomcatdeployment.yaml
```
To check the deployment status:
```
kubectl get deployment
```

If we open the url `http://hostip:hostport` now, we will see only the default nginx welcome page. To serve a static content, like a simple index.html, we replace the index.html file to the nginx default /usr/share/nginx/html web server file path.

Create an `index.html` in the host machine and use volume mapping to mount the content to nginx default web server file path.

First, create config map for the index.html file we have created:

```
kubectl create configmap index.html --from-file index.html
```

Check if config map were created successfully using `kubectl get configmaps`

Now,we need to tell the nginx Pod to read from this configmap for its content. 
Update the deployment file and add the below lines under specification to add a Volume mount, essentially treating the content of the content map like a mountable file inside the file system of the nginx container.

```
Spec:
        volumeMounts:
        - name: htmlcontent
          mountPath: "/usr/share/nginx/html/"
          readOnly: true
      volumes:
      - name: htmlcontent
        configMap:
          name: index.html
          items:
          - key: index.html
            path: index.html
```

Now, if we open the url `http://hostip:hostport`, we will be able to see the content of the `index.html` file, which we created.

