#!/bin/bash
# VERSION=${DB_ORDER_HOST}-$(date +%Y%m%d%H%M)
# mkdir /backups/order/${VERSION}
# mariabackup --backup --compress --target-dir /backups/$VERSION -H $DB_ORDER_HOST -u $DB_USER -p $DB_PASSWORD --databases=$DB_NAME --log=/logs/$VERSION.log 
# tar -czvf /backups/order/${VERSION}.tar.gz /backups/order/${VERSION}
# s3cmd --no-check-certificate put /backups/order/${VERSION}.tar.gz s3://order
# rm -rf /backups/order/${VERSION}.tar.gz

VERSION=order-$(date +%Y%m%d%H%M)
echo "Backing up order db version: ${VERSION}" >> /logs/order.log
mysqldump -u $DB_USER -h $DB_ORDER_HOST $DB_NAME  > /backups/order/${VERSION}.sql
scp /backups/order/${VERSION}.sql portalbk@172.16.1.251:order
M_SIZE=$(find /backups/order/${VERSION}.sql -printf "%s")
echo $VERSION-$M_SIZE >> /logs/order.log
rm -rf /backups/order/${VERSION}.sql
echo "End backing up order db version: ${VERSION}" >> /logs/order.log