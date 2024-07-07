#!/bin/bash -eux -o pipefail

# start nginx
[ -z $(which nginx) ] && /usr/local/bin/nginx_install.sh
[ ! -r /etc/ssl/certs/localhost.pem ] && /usr/local/bin/nginx_setup.sh
[ ! -r /app/models/.htpasswd ] && htpasswd -c -b /app/models/.htpasswd comfyui comfyui
nginx

# test for A100
SMI=$(nvidia-smi | grep A100)
EXTRA_OPTS=""
[ ! -z "${SMI}" ] && EXTRA_OPTS="--disable-cuda-malloc"
[ ! -z "${EXTRA_OPTS}" ] && echo "Adding extra opts: ${EXTRA_OPTS}"

# exec app
export COMFYUI_PATH=/app
export COMFYUI_MODEL_PATH=/app/models
cd /app
python3 -u main.py --listen 0.0.0.0 ${EXTRA_OPTS}
