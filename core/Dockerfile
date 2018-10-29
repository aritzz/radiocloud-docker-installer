FROM debian:stretch

RUN apt-get update
RUN apt-get install -y bash nano build-essential tar libgstreamer1.0-dev make default-libmysqlclient-dev libgstreamer-plugins-bad1.0-0 libgstreamer-plugins-base1.0-0 libgstreamer1.0-0 gstreamer1.0-alsa gstreamer1.0-pulseaudio alsa-utils gstreamer1.0-plugins-* ntp

ADD https://github.com/aritzz/radiocore/archive/1.2.tar.gz /
RUN tar -zxf /1.2.tar.gz && mv radiocore-1.2 radiocore

WORKDIR /radiocore
RUN sed -i "s/^DBHost.*/DBHost mysql/g" bin/radiocore.conf
RUN sed -i "s/^DBUser.*/DBUser root/g" bin/radiocore.conf
RUN sed -i "s/^DBPass.*/DBPass example/g" bin/radiocore.conf
RUN sed -i "s/^DBName.*/DBName radiocloud/g" bin/radiocore.conf
RUN sed -i "s/^TimeSignal.*/TimeSignal Off/g" bin/radiocore.conf



RUN make
RUN echo Europe/Madrid > /etc/timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

ADD run.sh . 
RUN chmod +x run.sh

CMD ["./run.sh"]
