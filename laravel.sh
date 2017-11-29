#!/bin/bash
function composer(){
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
    composer config -g repo.packagist composer https://packagist.phpcomposer.com    
}
function laravel(){
    mkdir /data/www/$1.jingyi-good.com 
    cd /data/www/$1.jingyi-good.com
    rm -rf $2
    composer create-project --prefer-dist laravel/$2
    cd $2
    if [ "$2" == "lumen" ];then
    lumen_cfg $1
    else
    laravel_cfg $1
    fi
    nginx_cfg $1 $2
    composer dump-autoload
    cd 
}
function lumen_cfg(){
    chmod -R 777 storage
    sed -i 's/UTC/Asia\/Shanghai\nAPP_ID=wxa02ce99b50401101\nAPP_SECRET=5c9e00d42a74132b5f153c49c8f32be6/g' .env
    sed -i 's/DB_DATABASE=homestead/DB_DATABASE='$1'/g' .env
    sed -i 's/DB_USERNAME=homestead/DB_USERNAME=root/g' .env
    sed -i 's/DB_PASSWORD=secret/DB_PASSWORD=jinjun123/g' .env 
}
function laravel_cfg(){
    chmod -R 777 storage
    chmod -R 777 bootstrap/cache
    sed -i 's/utf8mb4/utf8/g' config/database.php
    sed -i 's/DB_DATABASE=homestead/DB_DATABASE='$1'/g' .env
    sed -i 's/DB_USERNAME=homestead/DB_USERNAME=root/g' .env
    sed -i 's/DB_PASSWORD=secret/DB_PASSWORD=jinjun123/g' .env        
    sed -i 's/PUSHER_APP_SECRET=/PUSHER_APP_SECRET=\nAPP_ID=wxa02ce99b50401101\nAPP_SECRET=5c9e00d42a74132b5f153c49c8f32be6/g' .env
    sed -i 's/UTC/Asia\/Shanghai/g' config/app.php
}
function nginx_cfg(){
    cat >/etc/nginx/sites-available/$1.jingyi-good.com <<EOF
server {
    listen 80;
    server_name $1.jingyi-good.com;
    root /data/www/$1.jingyi-good.com/$2/public;
    index index.php;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php7.1-fpm.sock;
        include snippets/fastcgi-php.conf;
        fastcgi_param SCRIPT_FILENAME $document_root\$fastcgi_script_name;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
    sudo ln -s /etc/nginx/sites-available/$1.jingyi-good.com /etc/nginx/sites-enabled/$1.jingyi-good.com
    sudo nginx -t
    sudo systemctl restart nginx.service          
}
function nginx_cfg_for_lets(){
    cat >/etc/nginx/sites-available/$1.jingyi-good.com <<EOF
server {
    listen 80;
    server_name $1.jingyi-good.com;
    root /data/www/$1.jingyi-good.com/$2/public;
    index index.php;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php7.1-fpm.sock;
        include snippets/fastcgi-php.conf;
        fastcgi_param SCRIPT_FILENAME $document_root\$fastcgi_script_name;
    }

    location ~ /\.ht {
        deny all;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/$1.jingyi-good.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/$1.jingyi-good.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    if (\$scheme != "https") {
        return 301 https://\$host\$request_uri;
    } # managed by Certbot

}
EOF
    sudo nginx -t
    sudo systemctl restart nginx.service 
}