#!/bin/bash
# VERSION=${DB_VDC_HOST}-$(date +%Y%m%d%H%M)
# mkdir /backups/vdc/${VERSION}
# mariabackup --backup --compress --target-dir /backups/$VERSION -H $DB_VDC_HOST -u $DB_USER -p $DB_PASSWORD --databases=$DB_NAME --log=/logs/$VERSION.log 
# tar -czvf /backups/vdc/${VERSION}.tar.gz /backups/vdc/${VERSION}
# s3cmd --no-check-certificate put /backups/vdc/${VERSION}.tar.gz s3://vdc
# rm -rf /backups/vdc/${VERSION}

VERSION=vdc-$(date +%Y%m%d%H%M)
echo "Backing up vdc db version: ${VERSION}" >> /logs/vdc.log
mysqldump -u $DB_USER -h $DB_VDC_HOST $DB_NAME  > /backups/vdc/${VERSION}.sql
scp /backups/vdc/${VERSION}.sql portalbk@172.16.1.251:vdc
#s3cmd --no-check-certificate put /backups/vdc/${VERSION}.sql s3://vdcs
M_SIZE=$(find /backups/vdc/${VERSION}.sql -printf "%s")
echo $VERSION-$M_SIZE >> /logs/vdc.log
rm -rf /backups/vdc/${VERSION}.sql
echo "End backing up vdc db version: ${VERSION}" >> /logs/vdc.log