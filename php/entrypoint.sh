#!/bin/bash

# This command is used to disable the `pam_loginuid` module, which is used to track user sessions.
# Disabling this module is useful in situations, such as when running cron jobs that don't require a user session.

function disableLonginUid(){

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

function main(){

    disableLonginUid
    setExecutionPermission
    launchPermissionsScript
    runPhpFpm

}

main