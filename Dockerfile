FROM tomcat:jdk8-openjdk-slim-buster
LABEL maintainer="chinmayaranju@gmail.com"
ADD sample.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD [“catalina.sh”, “run”]
