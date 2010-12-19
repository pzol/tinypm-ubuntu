mysqldump --opt  -u root -p --database tinypmdb | gzip -c9 > tinypmdb-`date +%Y%m%d-%H%M`.sql.gz
