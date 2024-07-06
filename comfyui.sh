#!/bin/sh

[ -z $(which nginx) ] && /usr/local/bin/nginx_install.sh
[ ! -r /etc/ssl/certs/localhost.pem ] && /usr/local/bin/nginx_setup.sh

# test for A100
A100=$(nvidia-smi | grep A100)
EXTRA_OPTS=""
[ ! -z $A100 ] && EXTRA_OPTS="--disable-cuda-malloc"

# exec app
cd /app
python3 -u main.py --listen 0.0.0.0 ${EXTRA_OPTS}
