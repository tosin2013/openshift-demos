#!/bin/bash 

if [ -z ${1} ];
then
  echo "Please pass basedomain" 
  echo "USAGE: $0 apps.ocp.example.com"
  exit 1
fi 

set -x 

export BASE_DOMAIN="${1}"


echo "Creating a root certificate and private key to sign the certificate for your services"

openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=GENERATED Inc./CN=${BASE_DOMAIN}' -keyout ${BASE_DOMAIN}.key -out ${BASE_DOMAIN}.crt


echo "Create a certificate and a private key for ${1}"

openssl req -out *.${BASE_DOMAIN}.csr -newkey rsa:2048 -nodes -keyout *.${BASE_DOMAIN}.key -subj "/CN=${BASE_DOMAIN}/O=GENREATED organization"
openssl x509 -req -days 365 -CA ${BASE_DOMAIN}.crt -CAkey ${BASE_DOMAIN}.key -set_serial 0 -in *.${BASE_DOMAIN}.csr -out *.${BASE_DOMAIN}.crt
