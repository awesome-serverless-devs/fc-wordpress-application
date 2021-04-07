#!/bin/bash
set -e

# copy wordpress.conf to nginx sites-enabled folder
echo "Initilizing..."
whoami

cp /mnt/auto/wordpress.conf /etc/nginx/sites-enabled/
chmod 777 -R /mnt/auto/wordpress/wp-content

echo "start nginx"
nginx -c /etc/nginx/nginx.conf

echo "start php-fpm"
echo "session.save_path=/mnt/auto/wordpress/sessions" >> /usr/local/etc/php/php.ini-production
php-fpm -c /usr/local/etc/php/php.ini-production -y /usr/local/etc/php-fpm.conf

sleep 5

while true
do
    nginx_server=`ps aux | grep nginx | grep -v grep`
    if [ ! "$nginx_server" ]; then
        echo "restart nginx ..."
        nginx -c /etc/nginx/nginx.conf
    fi
    php_fpm_server=`ps aux | grep php-fpm | grep -v grep`
    if [ ! "$php_fpm_server" ]; then
        echo "restart php-fpm ..."
        php-fpm -c /usr/local/etc/php/php.ini-production -y /usr/local/etc/php-fpm.conf
    fi
    sleep 10
done