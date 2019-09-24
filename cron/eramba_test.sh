docker exec -i eramba-community-docker_app_1 bash -c '/var/www/sites/eramba_community/app/Console/cake cron test'
chown -R apache:apache /var/www/sites/eramba_community
chmod 777 -R /var/www/sites/eramba_community/app/tmp
