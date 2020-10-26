ARG BASE_TAG
FROM php:${BASE_TAG}

# install (install-php-extensions)[https://github.com/mlocati/docker-php-extension-installer]
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/ 

ARG TIMEZONE="Asia/Chongqing"
ARG ALPINE_MIRROR="http://mirrors.aliyun.com/alpine/v3.12/main\nhttp://mirrors.aliyun.com/alpine/v3.12/community"
RUN echo -e "${ALPINE_MIRROR}" > /etc/apk/repositories && apk update

# install mixed tools
RUN apk add --no-cache --virtual .build-deps tzdata gcc g++ automake make autoconf

    # set timezone
RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    # install php extension
    install-php-extensions bcmath ctype fileinfo json mbstring openssl pdo tokenizer xml mongodb && \
    # install pecl extension
    # config: --enable-redis-igbinary=no --enable-redis-lzf=no --enable-redis-zstd=no
    yes no | pecl install redis-5.3.2 && \
    docker-php-ext-enable redis

RUN apk del --purge .build-deps

################################
# Install & configure supervisord
################################
RUN apk add --no-cache openrc supervisor && \
    rc-update add supervisord boot && \
    mkdir -p /etc/supervisor.d && \
    # install rsyslog
    # -- this sed command must be run, cause tty[1-6] not exists
    sed -i 's/^tty[0-9]::respawn/#&/g' /etc/inittab && \
    apk add --no-cache rsyslog && \
    rc-update add rsyslog boot
VOLUME ["/etc/supervisor.d"]
CMD ["/sbin/init"]
