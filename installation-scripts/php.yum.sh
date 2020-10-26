#!/usr/bin/env bash

###################
# Install php7.x or 8.x on CentOS 7 or 8
###################

# Usage:
# ./$0 <php_version>
# eg: ./$0 12

set -e
# enables a mode of the shell where all executed commands are printed to the terminal.
set -x

if [ $# -ne 2 ]; then
  echo "Usage: ./$0 <php_version> <centos_version>\n"
  exit 1
fi

PHP_VERSION=$(echo $1 | sed "s/\([0-9]*\)\.\([0-9]*\).*/\1\2/g")
CENTOS_VERSION=$2

# install remi repo
# Add EPEL and REMI repository
yum install -y https://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/remi-release-${CENTOS_VERSION}.rpm

# Install PHP
yum -y install yum-utils
yum-config-manager --enable remi-php${PHP_VERSION}
yum update -y
yum install -y php-cli

# install extension
extentions="
bcmath
ctype
fileinfo
json
mbstring
openssl
pdo
tokenizer
xml
mongodb
"
for ext in $extentions; do
  yum install -y php-$ext
done
php -m
