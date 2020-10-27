#!/usr/bin/env bash

# Usage:
# ./$0 <python_version> <python_source_url>
# eg: ./$0 3.8.5 https://www.python.org/ftp/python/3.8.5/Python-3.8.5.tgz
#
# system libs dependencies:
#   yum groupinstall -y 'Development Tools'

set -e
# enables a mode of the shell where all executed commands are printed to the terminal.
set -x

if [ $# -ne 2 ]; then
  echo "Usage: ./$0 <python_version> <python_source_url>\n"
  exit 1
fi

PYTHON_VERSION=$1
PYTHON_SOURCE_URL=$2

curl ${PYTHON_SOURCE_URL} -o /tmp/python-${PYTHON_VERSION}.tgz
cd /tmp
tar zxf python-${PYTHON_VERSION}.tgz
cd /tmp/Python-${PYTHON_VERSION}
yum install -y openssl-devel bzip2-devel libffi-devel
./configure prefix=/usr/local/python3
make altinstall && make clean

# set shortcut
ln -s $(ls /usr/local/python3/bin/python3* | grep -e '[0-9]$') /usr/local/bin/python3
ln -s $(ls /usr/local/python3/bin/pip3* | grep -e '[0-9]$') /usr/local/bin/pip3

# Clean
rm -rf /tmp/python-${PYTHON_VERSION}.tgz
rm -rf /tmp/Python-${PYTHON_VERSION}
