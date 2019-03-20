## Dockerfile
FROM debian:buster

MAINTAINER Aritz <aritz@radixu.info>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
apt-get install -y default-libmysqld-dev default-libmysqlclient-dev libxml2-dev gstreamer1.0-dev libcurl4-openssl-dev build-essential make libgstreamer-plugins* tar bash php-cli php-xml php-curl php-mysql nano

ADD https://github.com/aritzz/radiocloud-daemon/archive/1.2.tar.gz /
RUN tar -zxf /1.2.tar.gz &&cd /radiocloud-daemon-1.2 && make
WORKDIR /radiocloud-daemon-1.2

RUN echo Europe/Madrid > /etc/timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

RUN sed -i "s/^SQLHost.*/SQLHost mysql/g" daemon.conf
RUN sed -i "s/^SQLPort.*/SQLPort 3306/g" daemon.conf
RUN sed -i "s/^SQLUser.*/SQLUser root/g" daemon.conf
RUN sed -i "s/^SQLPass.*/SQLPass example/g" daemon.conf
RUN sed -i "s/^SQLDB.*/SQLDB radiocloud/g" daemon.conf
RUN cat daemon.conf
RUN mkdir /radiocloud-daemon-1.2/tmp
RUN chmod 777 /radiocloud-daemon-1.2/tmp
ADD run.sh . 
RUN chmod +x run.sh

CMD ["./run.sh"]
