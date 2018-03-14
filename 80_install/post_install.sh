#!/bin/bash

set -x

date
start_date=$(date)

chmod +x start_web.sh

wget -O dropbox.py https://www.dropbox.com/download?dl=packages/dropbox.py
chmod +x dropbox.py

wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -


echo ${start_date}
date
