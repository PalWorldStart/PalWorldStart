#!/usr/bin/env bash

source init_secret.sh

openssl genrsa -out cert/key.pem 2048
openssl req -new -x509 -key cert/key.pem -out cert/cert.pem -days 36500 -subj "/CN=$GOFS_SERVER_ADDR"
