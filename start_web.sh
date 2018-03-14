#!/bin/bash

set -x

export TZ=JST-9

httpd -V
httpd -M
php --version
whereis php
cat /proc/version
curl --version
printenv

if [ ! -v LOG_LEVEL ]; then
  export LOG_LEVEL="warn"
fi

vendor/bin/heroku-php-apache2 -C apache.conf www
