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

#change dir
cd /microweber

case $dbEngine in
    "mysql")
        cmd="php artisan microweber:install $adminEmail $adminUsername $adminPassword $dbHost $dbName $dbUsername $dbPassword mysql"
        ;;
    
    "pgsql")
        cmd="php artisan microweber:install $adminEmail $adminUsername $adminPassword $dbHost $dbName $dbUsername $dbPassword pgsql"
        ;;
        
    "sqlite")
        dbHost="/microweber/storage/database.sqlite"
        cmd="php artisan microweber:install $adminEmail $adminUsername $adminPassword $dbHost"
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

#install
$cmd
echo $cmd

#ownerships if SQLite
if [ $dbEngine == "sqlite" ];then
    chmod -R 0775 $dbHost
    chown -R nginx:nginx $dbHost
fi

