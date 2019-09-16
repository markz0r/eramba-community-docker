#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

CRON_DIR="/data/eramba/cron"

# CP to data directory
mkdir -p ${CRON_DIR}
cp ./cron/*.sh ${CRON_DIR}/

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
