#!/bin/bash

sudo apt-get update -y
sudo apt-get install git -y
git clone https://github.com/dannetrichard/init.git
cd init
chmod +x ./init.sh
./init.sh 