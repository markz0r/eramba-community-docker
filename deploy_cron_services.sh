#!/bin/bash

CRON_DIR="/data/eramba/cron"

echo "This assumes you want to use systemd services to schedule eramba cron jobs"
echo "Enter the domain of your service (ie: eramba.mycompany.com / localhost)"
read MY_URL

echo "Enter your API key, accessible via: Setting/Cron Jobs in the web interface, ensure you have 'Web' selected"
read MY_API_KEY

# CP to data directory
mkdir -p ${CRON_DIR}
cp ./cron/*.sh ${CRON_DIR}/

# Update URL
sed -i "s#ADD_YOUR_URL#${MY_URL}#g" ${CRON_DIR}/eramba_hourly.sh 
sed -i "s#ADD_YOUR_URL#${MY_URL}#g" ${CRON_DIR}/eramba_daily.sh 
sed -i "s#ADD_YOUR_URL#${MY_URL}#g" ${CRON_DIR}/eramba_yearly.sh 

# Update API key
sed -i "s#ADD_API_KEY#${MY_API_KEY}#g" ${CRON_DIR}/eramba_hourly.sh 
sed -i "s#ADD_API_KEY#${MY_API_KEY}#g" ${CRON_DIR}/eramba_daily.sh 
sed -i "s#ADD_API_KEY#${MY_API_KEY}#g" ${CRON_DIR}/eramba_yearly.sh 

# Add timers to systemd services
cp ./cron/*.timer /etc/systemd/system/
# Add services
cp ./cron/*.service /etc/systemd/system/

systemctl start eramba-hourly.timer
systemctl start eramba-daily.timer
systemctl start eramba-yearly.timer
systemctl start eramba-hourly.service
systemctl start eramba-daily.service
systemctl start eramba-yearly.service


systemctl enable eramba-hourly.timer
systemctl enable eramba-daily.timer
systemctl enable eramba-yearly.timer
systemctl enable eramba-hourly.service
systemctl enable eramba-daily.service
systemctl enable eramba-yearly.service

systemctl daemon-reload
echo "LISTING TIMERS:"
systemctl list-timers
echo "LISTING ERAMBA SERVICES:"
systemctl list-units | grep eramba
