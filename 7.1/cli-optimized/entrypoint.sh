#!/bin/sh
if [ -z "$1" ]
  then
      env="dev"
else
      env=$1
fi
sed -i '/session.*required.*pam_loginuid.so/s/session/#session/g' /etc/pam.d/cron
/bin/autostart.sh $env
(crontab -l 2>/dev/null; echo "* * * * * /bin/autostart.sh $env") | crontab -
service cron start
echo "cron job started"
echo "php7 container launche daemons"
tail -f /dev/null
