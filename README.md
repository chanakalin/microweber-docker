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
| /microweber/ | Microweber installation |


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
| fresh | Install a fresh copy or continue with the existing if any | no | Y/N |


If there's no any existing installation and fresh=N a fresh installation will be perfromed.


Following ports will be using for mysql and pgsql database engines
| DB Engine | Port |
| --- | --- |
| MySQL | 3306 |
| PostgreSQL | 5432 |


Execute following to create a docker instance mounting storage,userfiles and config directories at the same working directory

```bash   
export adminEmail="admin@example.com"; export adminUsername="admin"; export adminPassword="abc@123"; export dbEngine="sqlite";
docker run -it --privileged=true --tmpfs /tmp --tmpfs /run -p 0.0.0.0:80:80  -v $(pwd)/microweber:/microweber/ --env adminEmail --env adminUsername --env adminPassword --env dbEngine microweber
```

## Docker compose - MySQL ##
Docker compose can use to create a deploymet consisting both MySQL database and microweber

Execute following inside of the directory
```bash 
docker-compose -f docker-compose-mysql.yml -p microweber-mysql up -d
```
