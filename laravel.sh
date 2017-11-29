#!/bin/bash

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
    sudo ln -s /etc/nginx/sites-available/$1.jingyi-good.com /etc/nginx/sites-enabled/$1.jingyi-good.com
    sudo nginx -t
    sudo systemctl restart nginx.service 
}