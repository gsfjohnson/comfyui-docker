#!/bin/bash

# install nginx
if [ -z $(which nginx) ]; then
  sudo apt update
  sudo apt install -y nginx
fi

