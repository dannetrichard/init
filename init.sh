#!/bin/bash
mkdir -p /data/www 
sudo apt-get update -y
sh init/lnmp.sh
sh init/laravel.sh
laravel tiger laravel
laravel api lumen