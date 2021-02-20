#!/bin/bash

while getopts e:a:p:d:H:D:U:P:t:T: flag
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
    esac
done

#clear
rm -rfR /microweber/storage/* /microweber/storage/.* /microweber/userfiles/* /microweber/userfiles/.* /microweber/config/* /microweber/config/.*

#extract
unzip -d /microweber -x /microweber.zip
chown -R nginx:nginx /microweber
chmod -R 0775 /microweber/storage/ /microweber/userfiles/

#change dir
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

#permissions
chown -R nginx:nginx /microweber/userfiles/
chmod -R 0775 /microweber/userfiles/
chown -R nginx:nginx /microweber/config


#install
cd /microweber;
$cmd;
echo $cmd

#ownerships if SQLite
if [ $dbEngine == "sqlite" ];then
    chmod -R 0775 $dbHost
    chown -R nginx:nginx $dbHost
fi

#init
/usr/bin/supervisord -n
