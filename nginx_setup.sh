#!/bin/bash

CERT_FN=/etc/ssl/certs/localhost.pem
KEY_FN=/etc/ssl/private/localhost.key

# install nginx
#if [ -z $(which nginx) ]; then
#  apt update
#  apt install -y nginx
#fi

# create certificates
if [ ! -r $CERT_FN ]; then
  openssl req -nodes -new -x509 -keyout $KEY_FN -out $CERT_FN -subj "/CN=localhost"
fi



# create reverse proxy
#cat <<EOFEOF >/etc/nginx/sites-enabled/reverse.conf
#server {
#  listen              443 ssl;
#  server_name         localhost;

#  ssl_certificate     /etc/ssl/certs/localhost.pem;
#  ssl_certificate_key /etc/ssl/certs/localhost.key;

#  location / {
#    proxy_pass   http://docker.internal.host:8188/;
#  }

#}
#EOFEOF
