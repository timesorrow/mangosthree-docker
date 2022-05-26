FROM rikorose/gcc-cmake:latest as builder
ARG MANGOS_SERVER_VERSION=master
ARG THREAD_COUNT="-j8"

RUN apt-get update -qq && \
    cmake --version && \
    apt-get install openssl libssl-dev -y && \
    git clone https://github.com/timesorrow/server.git -b ${MANGOS_SERVER_VERSION} --recursive && \
    cd server && \
    cmake . -DBUILD_REALMD=No -DBUILD_TOOLS=No -DCONF_DIR=conf/ && \
    make ${THREAD_COUNT} && \
    make install ${THREAD_COUNT}
