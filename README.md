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

| Environment variable | Description | Mandatory or nor | Acceptable values |
| --- | --- | --- | --- |
| adminEmail | Admin users email | Yes | String |
| adminUsername | Admin username | Yes | String |
| adminPassword | Admin password | Yes | String |
| dbEngine | Database engine | Yes | sqlite/mysql/pgsql |
| dbHost | Database host | Only for pgsql and mysql dbEngines | String |
| dbUsername | Database username | Only for pgsql and mysql dbEngines | String |
| dbPassword | Database password | Only for pgsql and mysql dbEngines | String |
| dbName | Database name | Only for pgsql and mysql dbEngines | String |
| dbTablePrefix | Database table prefix | no | String |
| template | Microweber template | no | String |


Execute following to create a docker instance mounting storage,userfiles and config directories at the same working directory

```bash   
export adminEmail="admin@example.com"; export adminUsername="admin"; export adminPassword="abc@123"; export dbEngine="sqlite";
docker run -it --privileged=true --tmpfs /tmp --tmpfs /run -p 0.0.0.0:8080:80  -v $(pwd)/storage:/microweber/storage -v $(pwd)/userfiles:/microweber/userfiles -v $(pwd)/config:/microweber/config --env adminEmail --env adminUsername --env adminPassword --env dbEngine microweber
```
