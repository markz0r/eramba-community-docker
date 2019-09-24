docker exec -i eramba-community-docker_app_1 bash -c '/var/www/sites/eramba_community/app/Console/cake cron job daily'
docker exec -i eramba-community-docker_app_1 bash -c 'chown -R apache:apache /var/www/sites/eramba_community'
docker exec -i eramba-community-docker_app_1 bash -c 'chmod 777 -R /var/www/sites/eramba_community/app/tmp'
