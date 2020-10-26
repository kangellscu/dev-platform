#!/usr/bin/env bash

###################
# Install mongo on CentOS 7 or 8
###################

# Usage:
# ./$0 <mongo_version> <centos_version>
# eg: ./$0 12

set -e
# enables a mode of the shell where all executed commands are printed to the terminal.
set -x

if [ $# -ne 2 ]; then
  echo "Usage: ./$0 <mongo_version> <centos_version>\n"
  exit 1
fi

MONGO_VERSION=$(echo $1 | sed "s/\([0-9]*\.[0-9]*\).*/\1/g")
CENTOS_VERSION=$2

# install repo
echo "[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/${CENTOS_VERSION}/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc" >> /etc/yum.repos.d/mongodb-org-${MONGO_VERSION}.repo

# install mongo shell & tools
yum install -y mongodb-org-shell mongodb-org-tools
