FROM celiangarcia/gcc7-cmake as builder
ARG MANGOS_SERVER_VERSION=master
ARG THREAD_COUNT="-j8"

RUN apt-get update -qq && \
    cmake --version && \
    apt-get install openssl libssl-dev -y && \
    git clone https://github.com/mangosthree/server.git -b ${MANGOS_SERVER_VERSION} --recursive && \
    cd server
    
    
