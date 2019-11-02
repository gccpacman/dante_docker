FROM ubuntu:16.04
MAINTAINER gccpacman(gccpacman@gmail.com)

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN sed -i '/security.ubuntu.com/d' /etc/apt/sources.list
RUN apt-get update && apt-get install -yq build-essential python-gssapi vim dnsutils net-tools telnet curl

ADD dante-1.4.1.tar.gz /usr/src
RUN cd /usr/src/dante-1.4.1/ && ./configure && make && make install
RUN mkdir -p /etc/dante/

RUN groupadd soksgroup
RUN useradd -p $(openssl passwd -1 password) soksuser

ADD config/sockd.conf /etc/dante/sockd.conf

ENV PIDFILE="/var/run/sockd.pid"
ENV CFGFILE="/etc/dante/sockd.conf"
ENV WORKERS 4

EXPOSE 1080

CMD sockd -p $PIDFILE -f $CFGFILE -N $WORKERS
