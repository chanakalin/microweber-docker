#!/bin/bash

cd /microweber
php artisan microweber:install admin@site.com admin password /microweber/storage/database.sqlite
