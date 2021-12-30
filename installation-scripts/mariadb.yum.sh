#!/usr/bin/env bash

###################
# Install mariadb client on CentOS 7 or 8
###################

# Usage:
# ./$0 <mariadb_version> <centos_version>
# eg: ./$0 12

set -e
# enables a mode of the shell where all executed commands are printed to the terminal.
set -x

if [ $# -ne 2 ]; then
  echo "Usage: ./$0 <mariadb_version> <centos_version>\n"
  exit 1
fi

MARIADB_VERSION=$(echo $1 | sed "s/\([0-9]*\.[0-9]*\).*/\1/g")
CENTOS_VERSION=$2

# install repo
echo "[mariadb]
name = MariaDB-${MARIADB_VERSION}
baseurl=http://yum.mariadb.org/${MARIADB_VERSION}/centos${CENTOS_VERSION}-amd64
# alternative: baseurl=http://archive.mariadb.org/mariadb-${MARIADB_VERSION}/yum/centos${CENTOS_VERSION}-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1" >> /etc/yum.repos.d/mariadb-${MARIADB_VERSION}.repo

# install mariadb client
yum install -y MariaDB-client
