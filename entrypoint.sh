#!/bin/sh

if [ $1 = "api" ]
then
    if [ -z $2 ]
    then
        env="dev"
    else
        env=$2
    fi
    echo "php7 container launche daemons"
    su -s /bin/sh -c '/usr/local/bin/php /pipeline/source/bin/console doctrine:schema:update -f  --env=$env >  /tmp/doctrine' www-data
    (crontab -l 2>/dev/null; echo "* * * * * /pipeline/source/ecs/autostart.sh $env") | crontab -
    (crontab -l 2>/dev/null; echo "0 23 * * * /pipeline/source/ecs/validate_channel_configs.sh $env") | crontab -
    (crontab -l 2>/dev/null; echo "* * * * * su -s /bin/sh -c '/usr/local/bin/php /pipeline/source/bin/console ttp:blog:publish-scheduled-articles --env=$env > /tmp/schedule-article.log' www-data") | crontab -
    service cron start
    /pipeline/source/ecs/autostart.sh $env
    tail -f /dev/null
else
   php-fpm
fi
