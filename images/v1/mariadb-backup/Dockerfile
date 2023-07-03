FROM mariadb

RUN apt-get update -y  && apt-get -y install cron
RUN apt-get install cron -y 
RUN apt-get install vim -y
RUN apt-get install mariadb-backup
RUN apt-get install s3cmd -y

RUN mkdir /configs
COPY ./configs /configs
COPY ./.s3cfg /root
COPY ./.s3cfg ~/
COPY ./casdb /etc/cron.d
COPY ./.my.cnf /root
COPY ./.my.cnf ~/

RUN mkdir /logs
RUN mkdir /backups
RUN mkdir /backups/auth
RUN mkdir /backups/order
RUN mkdir /backups/vdc
RUN mkdir /backups/mail

RUN service cron start

CMD ['crontab', '/etc/cron.d/casdb']