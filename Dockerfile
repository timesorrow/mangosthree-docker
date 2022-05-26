FROM ubuntu:18.04
ARG MANGOS_SERVER_VERSION=master
ARG THREAD_COUNT="-j8"

RUN apt update && apt upgrade -y && \
    apt-get install sudo && \
    adduser mangos && \
    echo "mangos:mangos" | chpasswd && \
    usermod -aG sudo mangos && \
    apt-get install git wget sudo make libssl-dev libbz2-dev build-essential default-libmysqlclient-dev libace-6.4.5 libace-dev python -y && \
    
    wget http://www.cmake.org/files/v3.12/cmake-3.12.1.tar.gz  && \
    tar -xvzf cmake-3.12.1.tar.gz && \
    cd cmake-3.12.1/ && \
    ./configure && \
    make && \
    make install  && \
    update-alternatives --install /usr/bin/cmake cmake /usr/local/bin/cmake 1 --force && \
    cmake --version && \
    cd /home/mangos && \
    mkdir /home/mangos/sources && \
    mkdir /home/mangos/build && \
    mkdir /home/mangos/db && \
    chown -R mangos:root sources && \
    chown -R mangos:root build && \
    chown -R mangos:root db && \
    cd /opt/ && \
    mkdir wow && \
    chown -R mangos:root wow && \
    chmod g+s wow && \
    cd /opt && \
    mkdir wow/install && mkdir wow/install/mangos && mkdir wow/install/mangos/bin && mkdir wow/install/mangos/bin/logs && mkdir wow/install/mangos/conf  && \
    cd /opt/wow && mkdir gamedata && mkdir gamedata/1.12 && mkdir gamedata/1.12/mangos
    
USER mangos

RUN cd /home/mangos/sources && \
    git clone https://github.com/mangosthree/server.git . --recursive --depth=1
RUN cd /home/mangos/build && \
    cmake ../sources/ -DCMAKE_INSTALL_PREFIX=/opt/wow/install/mangos -DCONF_INSTALL_DIR=/opt/wow/install/mangos/conf && \
    make -j4 
USER root
RUN cd /home/mangos/build && \
    make install
   
CMD ["bash"]
    
