#!/bin/bash
set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
cd "${script_dir}/../certs"

openssl genrsa -out ca.privkey 2048
openssl req -x509 -new -nodes -key ca.privkey -sha256 -days 1825 -out ca.cert -subj '/C=US/ST=California/O=Google LLC/CN=Fake CA'
openssl ecparam -out server.privkey -name prime256v1 -genkey
openssl req -new -sha256 -key server.privkey -out server.csr -subj /CN=try-amppackager.local
openssl x509 -req -in server.csr -CA ca.cert -CAkey ca.privkey -CAcreateserial -out server.cert -days 3650 -extfile <(echo -e "1.3.6.1.4.1.11129.2.1.22 = ASN1:NULL")
cat server.cert ca.cert >fullchain.cert

openssl ecparam -out server.tls.privkey -name prime256v1 -genkey
openssl req -new -sha256 -key server.tls.privkey -out server.tls.csr -subj /CN=try-amppackager.local
openssl x509 -req -in server.tls.csr -CA ca.cert -CAkey ca.privkey -CAcreateserial -out server.tls.cert -days 3650

openssl req -new -sha256 -key ca.privkey -out ocsp.csr -subj '/C=US/ST=California/O=Google LLC/CN=ocsp.try-amppackager.local'
openssl x509 -req -in ocsp.csr -signkey ca.privkey -out ca.ocsp.cert -extfile <(echo -e "keyUsage = critical, digitalSignature\nextendedKeyUsage = critical, OCSPSigning\n")

cat server.cert | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64 | tee fingerprint.txt
cat server.tls.cert | openssl x509 -pubkey | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64 | tee fingerprint.tls.txt
