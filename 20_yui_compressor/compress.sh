#!/bin/bash

set -x

wget $(curl https://java.com/en/download/manual.jsp \
 | grep 'Download Java software for Linux x64"' \
 | head -n 1 \
 | grep -oP 'http:.+?BundleId=[0-9a-z_]+') -O java.tar.gz


if [ ! -e ./java.tar.gz ]; then

  wget $(curl -b /tmp/cookie -c /tmp/cookie -L --data-urlencode 'u=https://java.com/en/download/manual.jsp' \
   -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:57.0) Gecko/20100101 Firefox/58.0' \
   https://webproxy.to/includes/process.php?action=update \
   | grep 'Download Java software for Linux x64"' \
   | head -n 1 \
   | grep -oP 'http.+BundleId%3D[0-9a-z_]+' \
   | php -r "echo urldecode(file_get_contents('php://stdin'));") -O java.tar.gz
   
  if [ ! -e ./java.tar.gz ]; then
    exit
  fi
fi

tar xvfz java.tar.gz

wget https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar

exts[0]='css'
exts[1]='js'

for ext in "${exts[@]}" ; do
  find /app/www/ttrss/ -name "*.${ext}" -type f -print0 | \
   xargs -0i -P $(grep -c -e processor /proc/cpuinfo) -n 1 bash ./sub01_compress.sh {} ${ext}
done
