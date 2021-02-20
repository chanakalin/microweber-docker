# microweber-docker

Microweber docker image is created on top of CentOS 8.
Nginx is using as the web server with php-fpm (Fast CGI processor).

## Build docker image
Execute following inside the directory containing Dockerfile and other required files to build docker image with the tag.
```bash   
docker build -t microweber ./
```

## Run docker image
Execute following to create a docker instance
```bash   
docker run -it --privileged=true --tmpfs /tmp --tmpfs /run -p 0.0.0.0:8080:80 microweber
```
