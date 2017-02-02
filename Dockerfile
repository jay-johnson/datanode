FROM centos:7
MAINTAINER Jay Johnson <jay.p.h.johnson@gmail.com>

RUN yum install -y \
    python-pip \
    python-devel \
    wget \
    python-setuptools 

RUN wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm -d && \
    yum localinstall mysql-community-release-el7-5.noarch.rpm -y && \
    yum install mysql-community-server -y && \
    rm mysql-community-release-el7-5.noarch.rpm && \
    yum clean all

RUN yum install -y MySQL-python epel-release

RUN yum update -y && yum install -y \
    autoconf \
    binutils \
    boost \
    boost-devel \
    build-essential \
    bzip2 \
    ca-certificates \
    cron \
    curl \ 
    curl-devel \
    emacs \
    fonts-dejavu \
    gcc \
    gcc-c++ \
    gfortran \
    git \
    hostname \
    jed \
    julia \
    libaio \
    libav-tools \
    libmysqlclient-dev \
    libnettle4 \
    libsm6 \
    libxml2-devel \
    libxrender1 \
    libxslt \
    libxslt-devel \
    locales \
    logrotate \
    llvm \
    llvm-devel \
    make \
    mariadb-server \
    mlocate \
    net-tools \
    pandoc \
    pcre-devel \
    perl \
    perl-devel \
    postgresql-devel \
    procps \
    pwgen \
    python-dev \
    python-devel \
    python-pip \
    python-setuptools \
    redis \
    rsyslog \
    sqlite \
    sqlite-devel \
    sudo \
    tar \
    telnet \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    tree \
    unzip \
    vim \
    vim-enhanced \
    wget \
    which \
    freetype \
    freetype-devel \
    libpng \
    libpng-devel \
    libpng-devel \
    python-virtualenv \
    mariadb-devel \
    libattr-devel \
    openssh \
    openssh-client \
    openssl-devel \
    libpcap \
    libpcap-devel \
    tkinter \
    && yum clean all

RUN easy_install pip && \
    /usr/bin/pip install --upgrade pip && \
    /usr/bin/pip install --upgrade setuptools 

# Environment Deployment Type
ENV ENV_DEPLOYMENT_TYPE DEV
ENV ENV_PROJ_DIR /opt/work
ENV ENV_DATA_DIR /opt/work/data
ENV ENV_DATA_SRC_DIR /opt/work/data/src
ENV ENV_DATA_DST_DIR /opt/work/data/dst
ENV ENV_SRC_DIR /opt/work/src
ENV ENV_THIRD_PARTY_DIR /opt/work/thirdparty
ENV ENV_CONFIGS_DIR /opt/work/configs

# Allow running starters from outside the container
ENV ENV_BIN_DIR /opt/work/bins
ENV ENV_PRESTART_SCRIPT /opt/tools/pre-start.sh
ENV ENV_START_SCRIPT /opt/tools/start-services.sh
ENV ENV_POSTSTART_SCRIPT /opt/tools/post-start.sh
ENV ENV_CUSTOM_SCRIPT /opt/tools/custom-pre-start.sh
ENV ENV_DEFAULT_VENV /venv
ENV ENV_AWS_ACCESS_KEY NOT_A_REAL_KEY
ENV ENV_AWS_SECRET_KEY NOT_A_REAL_KEY
ENV ENV_SET_AS_PYTHONPATH /opt/work

ENV ENV_SSH_CREDS /opt/shared/.ssh
ENV ENV_GIT_CONFIG /opt/shared/.gitconfig
ENV ENV_AWS_CREDS /root/.aws/credentials
ENV ENV_AWS_PROFILE default

RUN mkdir -p -m 777 /opt \
    && mkdir -p -m 777 /opt/deps \
    && mkdir -p -m 777 /opt/work \
    && mkdir -p -m 777 /opt/work/bins \
    && mkdir -p -m 777 /opt/work/configs \
    && mkdir -p -m 777 /opt/work/data \
    && mkdir -p -m 777 /opt/work/data/dst \
    && mkdir -p -m 777 /opt/work/data/src \
    && mkdir -p -m 777 /opt/work/src \
    && mkdir -p -m 777 /opt/work/thirdparty \
    && mkdir -p -m 777 /opt/shared \
    && mkdir -p -m 777 /opt/tools \
    && touch /tmp/firsttimerunning

WORKDIR /opt/work

# Add the starters and installers:
ADD ./docker/ /opt/tools/

RUN chmod 777 /opt/tools/*.sh \
    && mv /opt/tools/python2 /opt/ \
    && chmod 777 /opt/python2

RUN pushd /opt/python2 && /opt/python2/install_confluent_platform.sh && popd

RUN virtualenv /venv && /opt/python2/install_pips.sh

RUN /venv/bin/pip freeze > /opt/shared/python2-requirements.txt 

# Add files to start default-locations
RUN cp /opt/tools/bashrc /root/.bashrc \
    && cp /opt/tools/vimrc /root/.vimrc \
    && cp /opt/tools/gitconfig /root/.gitconfig \
    && cp /opt/tools/pre-start.sh /usr/local/bin/ \
    && cp /opt/tools/start-container.sh /usr/local/bin/ \
    && cp /opt/tools/post-start.sh /usr/local/bin/ \
    && cp /opt/tools/custom-pre-start.sh /usr/local/bin/ \
    && cp /opt/tools/start-services.sh /usr/local/bin/ \
    && cp /opt/tools/start-container.sh /opt/start-container.sh \
    && cp /opt/start-container.sh /usr/local/bin/start-container.sh \
    && chmod 644 /root/.bashrc && chown root:root /root/.bashrc \
    && cat /opt/tools/inputrc >> /etc/inputrc

CMD [ "/opt/start-container.sh" ]
