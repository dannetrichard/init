#!/bin/bash
mkdir -p /data/www 
sudo apt-get update -y
. ./lnmp.sh
. ./laravel.sh
composer
laravel tiger laravel
laravel api lumen


