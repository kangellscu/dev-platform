ARG BASE_TAG
FROM centos:${BASE_TAG}

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

ARG CENTOS_VERSION=7
ARG TIMEZONE="Asia/Chongqing"
RUN yum install -y wget && \
    # use aliyun mirror
    wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-${CENTOS_VERSION}.repo && \
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo && \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-${CENTOS_VERSION}.noarch.rpm && \
    yum update -y && \
    # install network tools
    yum install -y curl iputils net-tools && \
    yum groupinstall -y 'Development Tools' && \
    # set timezone
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    # mixed tools
    yum install -y bash bash-doc bash-completion vim && \
    # add user & group
    groupadd -g ${GID} ${GROUP} && \
    useradd -u ${UID} -g ${GID} --shell /bin/bash ${USER} && \
    # install git
    yum install -y git && \
    su ${USER} -c 'git config --global user.name "${GIT_USER}"' && \
    su ${USER} -c 'git config --global user.email "${GIT_EMAIL}"' && \
    su ${USER} -c 'git config --global core.editor vim' && \
    # install supervisor
    yum install -y supervisor && \
    systemctl enable supervisord && \
    mkdir -p /etc/supervisor.d && \
    # install rsyslog
    yum install -y rsyslog

#######################################
# Install & configure php cli
#######################################
ARG PHP_VERSION=${PHP_VERSION}
COPY ./php.yum.sh /tmp/php-install.sh
RUN source /tmp/php-install.sh ${PHP_VERSION} ${CENTOS_VERSION}
COPY ./composer-config.json /home/${USER}/.composer/config.json

# install composer
RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    rm -rf composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    chown -R ${USER}:${GROUP} /home/${USER}/.composer

#######################################
# Install & configure python
#######################################
#ln -s /usr/bin/python3 /usr/bin/python
ARG PYTHON_VERSION=3.8.5
ARG PYTHON_SOURCE_URL="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"
COPY ./python.yum.sh /tmp/python-install.sh
RUN source /tmp/python-install.sh ${PYTHON_VERSION} ${PYTHON_SOURCE_URL}

#######################################
# Install & configure nodejs & npm
#######################################
ARG NODEJS_VERSION=12
COPY ./nodejs.yum.sh /tmp/nodejs-install.sh
RUN source /tmp/nodejs-install.sh ${NODEJS_VERSION}

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
    sed -i 's/leikou:!!/leikou:*/g' /etc/shadow && \
    yum install -y openssh openssh-server && \
    systemctl enable sshd

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
# Vimrc customization
#######################################
COPY ./vimrc /etc/vim/vimrc
RUN cat /etc/vim/vimrc >> /etc/vimrc

VOLUME [ "/sys/fs/cgroup" ]

ARG WORKDIR=/home/${USER}
WORKDIR ${WORKDIR}

# Required, openrc will not working if init not invoked.
CMD ["/sbin/init"]

# Set user to ${USER}, default login user is ${USER} and all bind mount owner be the ${USER}
#USER ${USER}
