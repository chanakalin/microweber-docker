# microweber-docker #

Microweber docker image is created on top of CentOS 8.
Nginx is using as the web server with php-fpm (Fast CGI processor).

## Build docker image ##
Execute following inside the directory containing Dockerfile and other required files to build docker image with the tag.
```bash   
docker build -t microweber ./
```

## Run docker image ## 

Following volume mounts have to be provide in order to make persistant files
| Mounting point | Description |
| --- | --- |
| /microweber/storage | Laravel storage ( access logs, access SQLite database etc. ) |
| /microweber/config | Microweber configurations |
| /microweber/userfiles | Microweber user files |


Following environment variables has to be provide as "--env" options

| Environment variable | Description | Mandatory or nor |
| --- | --- | --- |
| adminEmail | Admin users email | Yes |
| adminUsername | Admin username | Yes |
| adminPassword | Admin password | Yes |
| dbEngine | Database engine ( sqlite/mysql/pgsql ) | Yes |
| dbHost | Database host | Only for pgsql and mysql dbEngines |
| dbUsername | Database username | Only for pgsql and mysql dbEngines |
| dbPassword | Database password | Only for pgsql and mysql dbEngines |
| dbName | Database name | Only for pgsql and mysql dbEngines |
| dbTablePrefix | Database table prefix | no |
| template | Microweber template | no |


Execute following to create a docker instance

```bash   
export adminEmail="admin@example.com"; export adminUsername="admin"; export adminPassword="abc@123"; export dbEngine="sqlite";
docker run -it --privileged=true --tmpfs /tmp --tmpfs /run -p 0.0.0.0:8080:80  -v storage:/microweber/storage -v userfiles:/microweber/userfiles -v config:/microweber/config --env adminEmail --env adminUsername --env adminPassword --env dbEngine microweber
```
