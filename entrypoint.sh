#!/bin/sh


fixApiWriteAccess() {
    chown -R www-data:www-data /pipeline/source/var
    chown -R www-data:www-data /pipeline/source/web/storage
    chown -R www-data:www-data /pipeline/source/app/db
}

if [ $1 = "api" ]
then
    if [ -z $2 ]
    then
        env="dev"
    else
        env=$2
    fi
    echo "php7 contianer launche daemons"
    /usr/local/bin/php /pipeline/source/bin/console doctrine:schema:update -f  --env=$env >  /tmp/doctrine
    fixApiWriteAccess
    su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttpmailer:daemon:start --env=$env </dev/null >/dev/null 2>&1 &" www-data
    su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttp:dir:push:daemon:start --sleep=2 --env=$env </dev/null >/dev/null 2>&1 &" www-data
    su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttp:dir:transfer-queue —env=$env </dev/null >/dev/null 2>&1 &" www-data
    su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttp:api:user-export-queue --env=$env --no-debug </dev/null >/dev/null 2>&1 &" www-data
    (crontab -l 2>/dev/null; echo "* * * * * /pipeline/source/ecs/autostart.sh $env") | crontab -
    (crontab -l 2>/dev/null; echo "0 23 * * * /pipeline/source/ecs/validate_channel_configs.sh $env") | crontab -
    (crontab -l 2>/dev/null; echo "* * * * * su -s /bin/sh -c '/usr/local/bin/php /pipeline/source/bin/console ttp:blog:publish-scheduled-articles --env=$env > /tmp/schedule-article.log' www-data") | crontab -
    service cron start
    tail -f /dev/null
else
   php-fpm
fi
