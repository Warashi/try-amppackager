#!/bin/sh
set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
cd "${script_dir}/../certs"

exec open -a 'Google Chrome' --args --ignore-certificate-errors-spki-list=$(cat fingerprint.txt),$(cat fingerprint.tls.txt)
