#!/bin/bash

# This command is used to disable the `pam_loginuid` module, which is used to track user sessions.
# Disabling this module is useful in situations, such as when running cron jobs that don't require a user session.

function disableLoginUid(){

    sed -i '/session.*required.*pam_loginuid.so/s/session/#session/g' /etc/pam.d/cron

}

# This is used to affect execution permission of the permissions.sh file.
function setExecutionPermission(){

    chmod +x /pipeline/source/ecs/permissions.sh

}

# This is used to run the permissions.sh file on the start of the contaier.
function launchPermissionsScript(){

    /pipeline/source/ecs/permissions.sh &

}

# This will run php-fpm.
function runPhpFpm(){

        echo "inside the run fpm function "  >> /tmp/permissons.log
        php-fpm

}

function runDoctrineSchemaUpdate(){

    ENIVRONMENT=$1
    su -s /bin/sh -c "/usr/local/bin/php -d memory_limit=-1 /pipeline/source/bin/console doctrine:schema:update -f  --env=$ENIVRONMENT >  /tmp/doctrine" www-data

}


function runDaemons(){

    # Checks for the current environment;
    if [ -z "$1" ]
    then
    
        ENVIRONMENT="dev"
        echo "The environment value hasn't been set correctly the default value will be dev" >> /tmp/daemons.log
        
    else

        ENVIRONMENT=$1
        echo "The environment value has been set correctly to $ENVIRONMENT" >> /tmp/daemons.log

    fi

    # Run the doctring schema update;
    runDoctrineSchemaUpdate $ENVIRONMENT

    # Run the script for the first initialization;
    /pipeline/source/ecs/autostart.sh $ENVIRONMENT

    # Setup and run cron jobs for the autostart.sh script;
    (crontab -l 2>/dev/null; echo "* * * * * /pipeline/source/ecs/autostart.sh $ENVIRONMENT") | crontab -
    (crontab -l 2>/dev/null; echo "0 23 * * * /pipeline/source/ecs/validate_channel_configs.sh $ENVIRONMENT") | crontab -
    (crontab -l 2>/dev/null; echo "* * * * * su -s /bin/sh -c '/usr/local/bin/php /pipeline/source/bin/console ttp:blog:publish-scheduled-articles --env=$ENVIRONMENT > /tmp/schedule-article.log' www-data") | crontab -
    service cron start
    echo "cron job started" >> /tmp/daemons.log
    echo "container daemons are launched ." >> /tmp/daemons.log

    tail -f /dev/null

}

function main(){

    disableLoginUid
    setExecutionPermission
    launchPermissionsScript
    runDaemons $1
    runPhpFpm

}

main $1