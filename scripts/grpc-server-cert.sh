#!/bin/bash

rm ./*.pem

#country
C="US"
#state
ST="Alabama"
#city (locality)
L="Hoover"
#organization
O="Side Hustle Labs"
#organization unit
OU="overton"
#common name
CN="*.stormbourne.com" #TODO: figure out what this is going to be in our cluster
#email address
emailAddress="shl@stormbourne.com"


SUBJ="/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${CN}/emailAddress=${emailAddress}/"

# this script is designed for running in Makefile, path needs to be relative to project root
certPath=./assets/certs
confPath=./config/cert

# 1. Generate CA's private key and self-signed certificate
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout $certPath/ca-key.pem -out $certPath/ca-cert.pem -subj "$SUBJ"

echo "CA's self-signed certificate"
openssl x509 -in $certPath/ca-cert.pem -noout -text

# 2. Generate grpc server's private key and certificate signing request (CSR)
echo "Generate PK and CSR"
openssl req -newkey rsa:4096 -nodes -keyout $certPath/server-key.pem -out $certPath/server-req.pem -subj "$SUBJ"

# 3. Use CA's private key to sign grpc server's CSR and get back the signed certificate
echo "Signing..."
openssl x509 -req -in $certPath/server-req.pem -days 60 -CA $certPath/ca-cert.pem -CAkey $certPath/ca-key.pem -CAcreateserial -out $certPath/server-cert.pem -extfile $confPath/server-ext.cnf

echo "Server's signed certificate"
openssl x509 -in $certPath/server-cert.pem -noout -text

