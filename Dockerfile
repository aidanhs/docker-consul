FROM       ubuntu:14.04
MAINTAINER Aidan Hobson Sayers <aidanhs@cantab.net>

# https://github.com/tianon/dockerfiles/blob/master/sbin-init/ubuntu/upstart/14.04/Dockerfile
# Steal the bare minimum to make upstart work
# >>>>>>>>>>>>>>>>
ADD init-conf/init-fake.conf /etc/init/fake-container-events.conf
RUN rm /usr/sbin/policy-rc.d; \
    rm /sbin/initctl; dpkg-divert --rename --remove /sbin/initctl
RUN /usr/sbin/update-rc.d -f ondemand remove; \
    for f in \
        /etc/init/u*.conf \
        /etc/init/mounted-dev.conf \
        /etc/init/mounted-proc.conf \
        /etc/init/mounted-run.conf \
        /etc/init/mounted-tmp.conf \
        /etc/init/mounted-var.conf \
        /etc/init/hostname.conf \
        /etc/init/networking.conf \
        /etc/init/tty*.conf \
        /etc/init/plymouth*.conf \
        /etc/init/hwclock*.conf \
        /etc/init/module*.conf\
    ; do \
        dpkg-divert --local --rename --add "$f"; \
    done; \
    echo '# /lib/init/fstab: cleared out for bare-bones Docker' > /lib/init/fstab
ENV container docker
# >>>>>>>>>>>>>>>>

RUN apt-get update && apt-get install -y curl bash git unzip && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -L https://dl.bintray.com/mitchellh/consul/0.4.1_linux_amd64.zip > /tmp/consul.zip && \
    cd /bin && unzip /tmp/consul.zip && chmod +x /bin/consul && rm /tmp/consul.zip

RUN curl -L https://dl.bintray.com/mitchellh/consul/0.4.1_web_ui.zip > /tmp/webui.zip && \
    mkdir /ui && cd /ui && unzip /tmp/webui.zip && rm /tmp/webui.zip

RUN curl -L https://get.docker.io/builds/Linux/x86_64/docker-1.2.0 > /bin/docker && \
    chmod +x /bin/docker

ADD . /config/
COPY init-conf/consul.conf /etc/init/

ADD ./start /bin/start
ADD ./check-http /bin/check-http
ADD ./check-cmd /bin/check-cmd

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp
VOLUME ["/data"]

ENV SHELL /bin/bash

ENTRYPOINT ["/bin/start"]
CMD []
