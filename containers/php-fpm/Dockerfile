ARG BASE_TAG
FROM php:${BASE_TAG}

# install (install-php-extensions)[https://github.com/mlocati/docker-php-extension-installer]
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/ 

ARG TIMEZONE="Asia/Chongqing"
ARG ALPINE_MIRROR="http://mirrors.aliyun.com/alpine/v3.12/main\nhttp://mirrors.aliyun.com/alpine/v3.12/community"
RUN echo -e "${ALPINE_MIRROR}" > /etc/apk/repositories && \
    apk update && \
    # install mixed tools
    apk add bash bash-doc bash-completion vim && \
    # set timezone
    apk add tzdata && \
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    apk del tzdata && \
    # install php extension
    install-php-extensions bcmath ctype fileinfo json mbstring openssl pdo tokenizer xml
