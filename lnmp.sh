#!/bin/bash
#mysql
sudo apt-get install mysql-server -y
#php
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update -y
sudo apt-get install php7.1 php7.1-cli php7.1-common php7.1-json php7.1-opcache php7.1-mysql php7.1-mbstring php7.1-mcrypt php7.1-zip php7.1-fpm php7.1-xml -y
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.1/cli/php.ini
sudo systemctl restart php7.1-fpm.service
sudo systemctl enable php7.1-fpm.service
#nginx
sudo apt-get install nginx -y
sudo systemctl restart nginx.service
sudo systemctl enable nginx.service
#!/bin/bash
#sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx 
#composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer config -g repo.packagist composer https://packagist.phpcomposer.com