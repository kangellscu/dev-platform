# https://hub.docker.com/r/openresty/openresty/
ARG OPENRESTY_TAG=1.17.8.2-5-centos
FROM openresty/openresty:${OPENRESTY_TAG}

ARG TIMEZONE="Asia/Chongqing"
RUN cp -f /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
