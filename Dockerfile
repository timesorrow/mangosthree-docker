FROM rikorose/gcc-cmake:latest as builder
ARG MANGOS_SERVER_VERSION=master
ARG THREAD_COUNT="-j8"

RUN apt-get update -qq && \
    cmake --version && \
    
