#!/bin/sh
set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
certs_dir="$(cd "${script_dir}/../certs"; pwd)"

exec google-chrome --args --ignore-certificate-errors-spki-list=$(cat "${certs_dir}/fingerprint.txt"),$(cat "${certs_dir}/fingerprint.tls.txt")
