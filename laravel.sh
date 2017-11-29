#!/bin/bash
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