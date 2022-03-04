#!/bin/sh
if [ -z "$1" ]
  then
      env="dev"
else
      env=$1
fi
sed -i '/session.*required.*pam_loginuid.so/s/session/#session/g' /etc/pam.d/cron
su -s /bin/sh -c "/usr/local/bin/php -d memory_limit=-1  /pipeline/source/bin/console doctrine:schema:update -f  --env=$env >  /tmp/doctrine" www-data
/pipeline/source/ecs/autostart.sh $env
(crontab -l 2>/dev/null; echo "* * * * * /pipeline/source/ecs/autostart.sh $env") | crontab -
(crontab -l 2>/dev/null; echo "0 23 * * * /pipeline/source/ecs/validate_channel_configs.sh $env") | crontab -
(crontab -l 2>/dev/null; echo "* * * * * su -s /bin/sh -c '/usr/local/bin/php /pipeline/source/bin/console ttp:blog:publish-scheduled-articles --env=$env > /tmp/schedule-article.log' www-data") | crontab -
service cron start
echo "cron job started"
echo "php7 container launche daemons"
tail -f /dev/null
