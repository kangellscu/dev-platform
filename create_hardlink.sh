#!/usr/bin/env bash

# Create hardlink for workspace
WORKSPACE_LINKS="
mongo.yum.sh
go.linux.sh
nodejs.yum.sh
php.yum.sh
python.yum.sh
"

for link_file in ${WORKSPACE_LINKS}; do
  ln installation-scripts/${link_file} containers/workspace/${link_file}
done
