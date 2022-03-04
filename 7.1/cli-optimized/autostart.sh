env=$1
if [ $env == '' ] ; then
        env='dev'
fi

if ps -ef | grep -v grep | grep ttpmailer ; then
        echo "TTP Mailer Running"
else
        /bin/su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttpmailer:daemon:start --env=$env </dev/null >/dev/null 2>&1 &" www-data
fi




if ps -ef | grep -v grep | grep 'enqueue:consume --client=ttp.wtb' ; then
        echo "Async wercker for WTB project"
else
        /bin/su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console enqueue:consume --client=ttp.wtb --setup-broker --env=$env --no-debug </dev/null >/dev/null 2>&1 &" www-data
fi



if ps -ef | grep -v grep | grep 'ttp:dir:deliver-document-queue' ; then
        echo "TTP Transfer document Running"
else
        /bin/su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttp:dir:deliver-document-queue --env=$env --no-debug </dev/null >/dev/null 2>&1 &" www-data
fi



if ps -ef | grep -v grep | grep "ttp:dir:handle-btb-channels --task=BTBFILES_FOLDER_STRUCTURE" ; then
        echo "TTP BTB channels async handler Running task : BTBFILES_FOLDER_STRUCTURE"
else
        /bin/su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttp:dir:handle-btb-channels --task=BTBFILES_FOLDER_STRUCTURE --env=$env --no-debug </dev/null >/dev/null 2>&1 &" www-data
fi



if ps -ef | grep -v grep | grep "ttp:dir:handle-btb-channels --task=BTBFILES_FOLDERS_DEFAULT_CHANNEL" ; then
        echo "TTP BTB channels async handler Running task : BTBFILES_FOLDERS_DEFAULT_CHANNEL"
else
        /bin/su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttp:dir:handle-btb-channels --task=BTBFILES_FOLDERS_DEFAULT_CHANNEL --env=$env --no-debug </dev/null >/dev/null 2>&1 &" www-data
fi




if ps -ef | grep -v grep | grep "ttp:dir:handle-btb-channels --task=BTB_FOLDERS_DEFAULT_CHANNEL" ; then
        echo "TTP BTB channels async handler Running task : BTB_FOLDERS_DEFAULT_CHANNEL"
else
        /bin/su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttp:dir:handle-btb-channels --task=BTB_FOLDERS_DEFAULT_CHANNEL --env=$env --no-debug </dev/null >/dev/null 2>&1 &" www-data
fi




if ps -ef | grep -v grep | grep "ttp:dir:handle-btb-channels --task=EMAIL_FOLDERS_DEFAULT_CHANNEL" ; then
        echo "TTP BTB channels async handler Running task : EMAIL_FOLDERS_DEFAULT_CHANNEL"
else
        /bin/su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttp:dir:handle-btb-channels --task=EMAIL_FOLDERS_DEFAULT_CHANNEL --env=$env --no-debug </dev/null >/dev/null 2>&1 &" www-data
fi


if ps -ef | grep -v grep | grep 'ttp:dir:notification-handler' ; then
        echo "TTP Notification handler Running"
else
        /bin/su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttp:dir:notification-handler --env=$env --no-debug </dev/null >/dev/null 2>&1 &" www-data
fi


if ps -ef | grep -v grep | grep 'ttp:api:send-webhooks' ; then
        echo "TTP Send Webhooks Running"
else
        /bin/su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttp:api:send-webhooks --env=$env --sleep=1 --no-debug </dev/null >/dev/null 2>&1 &" www-data
fi


if ps -ef | grep -v grep | grep 'ttp:mailing:fill:campaign-recipients' ; then
        echo "EMAILING Fill recipient Running"
else
     /bin/su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console ttp:mailing:fill:campaign-recipients --env=$env --no-debug </dev/null >/dev/null 2>&1 &" www-data
fi

if ps -ef | grep -v grep | grep 'campaign-mailer:spool:send' ; then
        echo "EMAILING Mailer running"
else
     /bin/su -s /bin/sh -c "/usr/bin/nohup /usr/local/bin/php /pipeline/source/bin/console campaign-mailer:spool:send --env=$env --no-debug </dev/null >/dev/null 2>&1 &" www-data
fi
