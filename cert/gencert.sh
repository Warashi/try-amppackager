#!/bin/bash
set -euo pipefail

openssl genrsa -out ca.privkey 2048
openssl req -x509 -new -nodes -key ca.privkey -sha256 -days 1825 -out ca.cert -subj '/C=US/ST=California/O=Google LLC/CN=Fake CA'
openssl ecparam -out server.privkey -name prime256v1 -genkey
openssl req -new -sha256 -key server.privkey -out server.csr -subj /CN=origin.local
openssl x509 -req -in server.csr -CA ca.cert -CAkey ca.privkey -CAcreateserial -out server.cert -days 3650 -extfile <(echo -e "1.3.6.1.4.1.11129.2.1.22 = ASN1:NULL")
cat server.cert ca.cert >fullchain.cert
