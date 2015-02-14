FROM       ubuntu:14.04
MAINTAINER Aidan Hobson Sayers <aidanhs@cantab.net>

RUN apt-get update && apt-get install -y curl bash git unzip && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -L https://dl.bintray.com/mitchellh/consul/0.4.1_linux_amd64.zip > /tmp/consul.zip && \
    cd /bin && unzip /tmp/consul.zip && chmod +x /bin/consul && rm /tmp/consul.zip

RUN curl -L https://dl.bintray.com/mitchellh/consul/0.4.1_web_ui.zip > /tmp/webui.zip && \
    mkdir /ui && cd /ui && unzip /tmp/webui.zip && rm /tmp/webui.zip

RUN curl -L https://get.docker.io/builds/Linux/x86_64/docker-1.2.0 > /bin/docker && \
    chmod +x /bin/docker

ADD . /config/

WORKDIR /config

RUN ln -s $(pwd)/start /bin/start && \
    ln -s $(pwd)/check-http /bin/check-http && \
    ln -s $(pwd)/check-cmd /bin/check-cmd

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp
VOLUME ["/data"]

ENV SHELL /bin/bash

ENTRYPOINT ["/bin/start"]
CMD []
