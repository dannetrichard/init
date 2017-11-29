#!/bin/bash

rm -rf init
mkdir -p /data/www/

sudo apt-get update -y
sudo apt-get install git -y
git clone https://github.com/dannetrichard/init.git
chmod +x ./init/*.sh

./init/pip3.sh
./init/nodejs.sh
./init/lnmp.sh
./init/laravel.sh
sudo certbot --nginx