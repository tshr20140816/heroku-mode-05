#!/bin/bash

set -x

date
start_date=$(date)

chmod +x start_web.sh

wget -O dropbox.py https://www.dropbox.com/download?dl=packages/dropbox.py
chmod +x dropbox.py

wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

postgres_user=$(echo ${DATABASE_URL} | awk -F':' '{print $2}' | sed -e 's/\///g')
postgres_password=$(echo ${DATABASE_URL} | grep -o '/.\+@' | grep -o ':.\+' | sed -e 's/://' | sed -e 's/@//')
postgres_server=$(echo ${DATABASE_URL} | awk -F'@' '{print $2}' | awk -F':' '{print $1}')
postgres_dbname=$(echo ${DATABASE_URL} | awk -F'/' '{print $NF}')

export PGPASSWORD=${postgres_password}

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
CREATE TABLE t_downloads
(
 url character varying(512) PRIMARY KEY
,file_name character varying(255) NOT NULL
,status int DEFAULT 0 NOT NULL
,create_time timestamp DEFAULT localtimestamp NOT NULL
)
__HEREDOC__
cat /tmp/sql_result.txt

echo ${start_date}
date
