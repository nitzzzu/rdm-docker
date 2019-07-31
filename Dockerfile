FROM ubuntu:16.04
RUN apt-get update && apt-get install -y git lsb-release sudo software-properties-common build-essential python3-dev
RUN mkdir /rdm && cd /rdm && git clone --recursive https://github.com/uglide/RedisDesktopManager.git .
RUN cd /rdm/src && ./configure
RUN cd /rdm/src && . /opt/qt59/bin/qt59-env.sh && qmake && make && sudo make install
RUN apt install -y python3-pip && pip3 install -r /rdm/src/py/requirements.txt
WORKDIR /opt/redis-desktop-manager
RUN mv qt.conf qt.backup
COPY rdm.sh .
RUN chmod 777 rdm.sh
CMD ./rdm.sh