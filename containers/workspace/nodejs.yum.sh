#!/usr/bin/env bash

# Usage:
# ./$0 <nodejs_version>
# eg: ./$0 12

set -e
# enables a mode of the shell where all executed commands are printed to the terminal.
set -x

if [ $# -ne 1 ]; then
  echo "Usage: ./$0 <nodejs_version>\n"
  exit 1
fi

NODEJS_VERSION=$1

yum remove -y nodejs npm

curl -sL https://rpm.nodesource.com/setup_${NODEJS_VERSION}.x | bash -
yum install -y nodejs
npm config set registry http://registry.npm.taobao.org
