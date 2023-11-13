FROM tamtampro/php:7.4-api

ADD ./entrypoint.sh /bin/entrypoint.sh

RUN apt update && apt-get install acl -y

RUN chmod +x /bin/entrypoint.sh
ENTRYPOINT [ "/bin/entrypoint.sh" ]
