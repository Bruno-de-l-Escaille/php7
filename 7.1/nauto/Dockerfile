FROM tamtampro/php:7.2-cli

ADD ./entrypoint.sh /bin/entrypoint.sh

RUN sed -i '/session.*required.*pam_loginuid.so/s/session/#session/g' /etc/pam.d/cron

ENTRYPOINT []
