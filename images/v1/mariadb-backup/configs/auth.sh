#!/bin/bash
# VERSION=auth-$(date +%Y%m%d%H%M)
# mkdir /backups/auth/${VERSION}
# mariabackup --backup --compress --target-dir /backups/auth/$VERSION -H $DB_AUTH_HOST -u $DB_USER -p $DB_PASSWORD --databases=$DB_NAME --log=/logs/$VERSION.log 
# tar -czvf /backups/auth/${VERSION}.tar.gz  /backups/auth/${VERSION}
# s3cmd --no-check-certificate put /backups/auth/${VERSION}.tar.gz s3://auths
# rm -rf /backups/auth/${VERSION}.tar.gz

VERSION=auth-$(date +%Y%m%d%H%M)
echo "Backing up auth db version: ${VERSION}" >> /logs/auth.log
mysqldump -u $DB_USER -h $DB_AUTH_HOST $DB_NAME  > /backups/auth/${VERSION}.sql
# s3cmd --no-check-certificate put /backups/auth/${VERSION}.sql s3://auths
scp /backups/auth/${VERSION}.sql portalbk@172.16.1.251:auth
M_SIZE=$(find /backups/auth/${VERSION}.sql -printf "%s")
echo $VERSION-$M_SIZE >> /logs/auth.log
rm -rf /backups/auth/${VERSION}.sql
echo "End backing up auth db version: ${VERSION}" >> /logs/auth.log
