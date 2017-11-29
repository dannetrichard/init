#!/bin/bash
mkdir -p /data/www 
sudo apt-get update -y
sh init/lnmp.sh
source init/laravel.sh
composer
laravel tiger laravel
laravel api lumen
