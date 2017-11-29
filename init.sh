#!/bin/bash
mkdir -p /data/www 
sudo apt-get update -y
sh lnmp.sh
source ./laravel.sh
composer
laravel tiger laravel
laravel api lumen


