#!/bin/sh
set -eu

chmod 777 -R /var/www/sites/eramba_community/app/tmp

### UPDATE THE DB DETAILS IN CONFIG ###
db_config_file_template="/var/www/sites/eramba_community/app/Config/database.php.default"
db_config_file="/var/www/sites/eramba_community/app/Config/database.php"
cp -f $db_config_file_template $db_config_file

sed -i "s#'host' => '',#'host' => '${MYSQL_HOSTNAME}',#g" ${db_config_file}
sed -i "s#'login' => '',#'login' => '${MYSQL_USER}',#g" ${db_config_file}
sed -i "s#'password' => '',#'password' => '${MYSQL_PASSWORD}',#g" ${db_config_file}
sed -i "s#'database' => '',#'database' => '${MYSQL_DATABASE}',#g" ${db_config_file}
sed -i "s#'prefix' => '',#'prefix' => '${DATABASE_PREFIX}',#g" ${db_config_file}
#######################################

sed -i "s/Listen 80$/Listen 8080/g" /etc/httpd/conf/httpd.conf

### STARTING APACHE ###
rm -vf /var/run/httpd/httpd.pid
exec httpd -DFOREGROUND
