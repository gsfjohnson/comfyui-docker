#!/bin/bash
# -eux -o pipefail

# start nginx
[ -z $(which nginx) ] && /nginx_install.sh
[ ! -r /etc/ssl/certs/localhost.pem ] && /nginx_setup.sh
[ ! -r /app/models/.htpasswd ] && htpasswd -c -b /app/models/.htpasswd comfyui comfyui
sudo nginx

# test for A100
SMI=$(nvidia-smi | grep A100)
EXTRA_OPTS=""
[ ! -z "${SMI}" ] && EXTRA_OPTS="--disable-cuda-malloc"
[ ! -z "${EXTRA_OPTS}" ] && echo "Adding extra opts: ${EXTRA_OPTS}"

# install requirements
for fn in `find /app -name requirements.txt`; do
  echo "******** $fn"
  [ -r ${fn//\/requirements.txt}/.pip_install_completed ] && continue
  pip install -r $fn
  touch ${fn//\/requirements.txt}/.pip_install_completed
done

# exec app
cd /app
python3 -u main.py --listen 0.0.0.0 ${EXTRA_OPTS}
