FROM ubuntu:18.04
ARG MANGOS_SERVER_VERSION=master
ARG THREAD_COUNT="-j8"

RUN apt-get update -qq && \
    adduser mangos && \
    usermod -aG sudo mangos && \
    apt install git sudo make cmake libssl-dev libbz2-dev build-essential default-libmysqlclient-dev libace-6.4.5 libace-dev python -y && \
    cmake --version && \
    mkdir /home/mangos/sources && \
    mkdir /home/mangos/build && \
    mkdir /home/mangos/db && \
    
    sudo su && \
    cd /opt/ && \
    mkdir wow && \
    chown -R mangos:root wow && \
    chmod g+s wow && \
    exit && \

    cd /opt && \
    mkdir wow/install && mkdir wow/install/mangos && mkdir wow/install/mangos/bin && mkdir wow/install/mangos/bin/logs && mkdir wow/install/mangos/conf  && \
    cd /opt/wow && mkdir gamedata && mkdir gamedata/1.12 && mkdir gamedata/1.12/mangos && \
    
    cd /home/mangos/sources && \
    git clone https://github.com/mangosthree/server.git . --recursive --depth=1
    
