#!/usr/bin/env bash

# Usage:
# ./$0 <package_url>

set -e
# enables a mode of the shell where all executed commands are printed to the terminal.
set -x

if [ $# -ne 1 ]; then
  echo "Usage: ./$0 <package_url>\n"
  exit 1
fi

PACKAGE_URL=$1

curl ${PACKAGE_URL} -o /tmp/go.tar.gz
tar -C /usr/local -xzf /tmp/go.tar.gz

# clean
rm -rf /tmp/go.tar.gz
