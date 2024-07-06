#!/bin/bash

# install nginx
if [ -z $(which nginx) ]; then
  apt update
  apt install -y nginx
fi

