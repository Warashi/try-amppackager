#!/bin/bash
set -euo pipefail

openssl genrsa -out ca.privkey 2048
openssl req -x509 -new -nodes -key ca.privkey -sha256 -days 1825 -out ca.cert -subj '/C=US/ST=California/O=Google LLC/CN=Fake CA'
openssl ecparam -out server.privkey -name prime256v1 -genkey
openssl req -new -sha256 -key server.privkey -out server.csr -subj '/CN=origin.local/O=Test/C=US'
openssl x509 -req -in server.csr -CA ca.cert -CAkey ca.privkey -CAcreateserial -out server.cert -days 3650 -extfile <(echo -e "1.3.6.1.4.1.11129.2.1.22 = ASN1:NULL\nsubjectAltName=DNS:origin.local")
cat server.cert ca.cert >fullchain.cert

openssl req -new -sha256 -key ca.privkey -out ocsp.csr -subj '/C=US/ST=California/O=Google LLC/CN=ocsp.origin.local'
openssl x509 -req -in ocsp.csr -signkey ca.privkey -out ca.ocsp.cert -extfile <(echo -e "keyUsage = critical, digitalSignature\nextendedKeyUsage = critical, OCSPSigning\n")

touch index.txt
openssl ocsp -index ./index.txt -rsigner ca.ocsp.cert -rkey ca.privkey -CA ca.cert -ndays 7 -issuer ca.cert -cert server.cert -respout /tmp/amppkg-ocsp

cat server.cert | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64 | tee fingerprints.txt
echo "open -a 'Google Chrome Canary' --args --ignore-certificate-errors-spki-list=$(cat fingerprints.txt)"
echo "google-chrome-unstable --args --ignore-certificate-errors-spki-list=$(cat fingerprints.txt)"
