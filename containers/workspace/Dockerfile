ARG BASE_TAG
FROM php:${BASE_TAG}

USER root

# install (install-php-extensions)[https://github.com/mlocati/docker-php-extension-installer]
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/ 

##############################################
# dev-platform non-user user
##############################################
ARG USER=dev
ARG GROUP=dev
ARG UID=1000
ARG GID=1000
ENV USER=${USER}
ENV GROUP=${GROUP}

ARG GIT_USER
ARG GIT_EMAIL

ARG ALPINE_MIRROR="http://mirrors.aliyun.com/alpine/v3.12/main\nhttp://mirrors.aliyun.com/alpine/v3.12/community"
ARG TIMEZONE="Asia/Chongqing"
RUN echo -e "${ALPINE_MIRROR}" > /etc/apk/repositories && \
    apk update && \
    # install network tools
    apk add curl wget iputils net-tools && \
    # set timezone
    apk add tzdata && \
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    apk del tzdata && \
    # mixed tools
    apk add bash bash-doc bash-completion vim && \
    # add user & group
    addgroup -g ${GID} ${GROUP} && \
    adduser -u ${UID} -G ${GROUP} -D ${USER} --shell /bin/bash && \
    # set hostname
    echo "workspace" > /etc/hostname && \
    # install php extension
    install-php-extensions bcmath ctype fileinfo json mbstring openssl pdo tokenizer xml phar mongodb && \
    # global install composer
    php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    rm -rf composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    # install git
    apk add git && \
    su ${USER} -c 'git config --global user.name "${GIT_USER}"' && \
    su ${USER} -c 'git config --global user.email "${GIT_EMAIL}"' && \
    su ${USER} -c 'git config --global core.editor vim' && \
    # install supervisor
    apk add openrc supervisor && \
    rc-update add supervisord boot && \
    mkdir -p /etc/supervisor.d && \
    # install rsyslog
    # -- this sed command must be run, cause tty[1-6] not exists
    sed -i 's/^tty[0-9]::respawn/#&/g' /etc/inittab && \
    apk add rsyslog && \
    rc-update add rsyslog boot && \
    # create soft link for python
    ln -s /usr/bin/python3 /usr/bin/python && \
    # install nodejs & npm
    apk add nodejs npm

#######################################
# Install & configure ssh
#######################################
COPY ./sshd_config /etc/ssh/sshd_config
RUN mkdir -p /home/${USER}/.ssh/keys && \
    chmod 700 /home/${USER}/.ssh && \
    chmod 700 /home/${USER}/.ssh/keys && \
    touch /home/${USER}/.ssh/keys/${USER} && \
    chmod 400 /home/${USER}/.ssh/keys/${USER} && \
    touch /home/${USER}/.ssh/authorized_keys && \
    chmod 600 /home/${USER}/.ssh/authorized_keys && \
    touch /home/${USER}/.ssh/config && \
    chown -R ${USER}:${GROUP} /home/${USER}/.ssh && \
    # Resolve ssh connection refused cause account be locked
    sed -i 's/leikou:!/leikou:*/g' /etc/shadow && \
    apk add openssh && \
    rc-update add sshd boot

#######################################
# User aliases
#######################################
COPY ./aliases.sh /root/.aliases.sh
COPY ./aliases.sh /home/${USER}/.aliases.sh
RUN echo "source ./.aliases.sh" >> /root/.bashrc && \
    echo "source ./.aliases.sh" >> /home/${USER}/.bashrc && \
    echo "source ./.bashrc" >> /home/${USER}/.bash_profile && \
    chown ${USER}:${GROUP} /home/${USER}/.aliases.sh && \
    chown ${USER}:${GROUP} /home/${USER}/.bashrc && \
    chown ${USER}:${GROUP} /home/${USER}/.bash_profile

#######################################
# Vimrc
#######################################
COPY ./vimrc /etc/vim/vimrc

#######################################
# Composer mirror config
#######################################
COPY ./composer.json /home/${USER}/.composer/composer.json
RUN chown -R ${USER}:${GROUP} /home/${USER}/.composer

#######################################
# SSHD configuration
#######################################

VOLUME [ "/sys/fs/cgroup" ]

ARG WORKDIR=/home/${USER}
WORKDIR ${WORKDIR}

# Required, openrc will not working if init not invoked.
CMD ["init"]

# Set user to ${USER}, default login user is ${USER} and all bind mount owner be the ${USER}
#USER ${USER}
