#!/bin/bash

while getopts e:a:p:d:H:D:U:P:t:T:R:f: flag
do
    case "${flag}" in
        e) adminEmail=${OPTARG};;
        a) adminUsername=${OPTARG};;
        p) adminPassword=${OPTARG};;
        d) dbEngine=${OPTARG};;
        H) dbHost=${OPTARG};;
        D) dbUsername=${OPTARG};;
        U) dbPassword=${OPTARG};;
        P) dbName=${OPTARG};;
        t) dbTablePrefix=${OPTARG};;
        T) template=${OPTARG};;
        f) fresh=${OPTARG};;
    esac
done

#always a fresh install
export fresh=Y

#extract
if [ ${fresh^h}=="Y" ];then
    #overwrite
    unzip -q -o -d /microweber -x /microweber.zip
else
    #never overwrite
    unzip -q -n -d /microweber -x /microweber.zip
fi

#ownership
chown -R nginx:nginx /microweber
chmod -R 0775 /microweber/storage/ /microweber/userfiles/
#permissions
chown -R nginx:nginx /microweber/userfiles/
chmod -R 0775 /microweber/userfiles/
chown -R nginx:nginx /microweber/config


#install if  fresh
if [ ${fresh^h}=="Y" ];then
    #change directory
    cd /microweber;
    cmd="php artisan microweber:install"
    case $dbEngine in
        "mysql")
            cmd="$cmd $adminEmail $adminUsername $adminPassword $dbHost $dbName $dbUsername $dbPassword mysql"
            ;;    
        "pgsql")
            cmd="$cmd $adminEmail $adminUsername $adminPassword $dbHost $dbName $dbUsername $dbPassword pgsql"
            ;;
        "sqlite")
            dbHost="/microweber/storage/database.sqlite"
            cmd="$cmd $adminEmail $adminUsername $adminPassword $dbHost"
            ;;
    esac
    #table prefix
    if [ -n "$dbTablePrefix" ];
    then
        cmd="$cmd -p $dbTablePrefix"
    fi
    #template
    if [ -n "$template" ];
    then
        cmd="$cmd -t $template"
    fi 
    #execute
    $cmd;
    echo $cmd
    
    #ownerships if SQLite
    if [ $dbEngine == "sqlite" ];then
        chmod -R 0775 $dbHost
        chown -R nginx:nginx $dbHost
    fi
fi


#ownership
chown -R nginx:nginx /microweber
chmod -R 0775 /microweber/storage/ /microweber/userfiles/
#permissions
chown -R nginx:nginx /microweber/userfiles/
chmod -R 0775 /microweber/userfiles/
chown -R nginx:nginx /microweber/config


#init
setenforce 0
/usr/bin/supervisord -c /etc/supervisord.conf -n
