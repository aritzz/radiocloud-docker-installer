# Dockerfile
FROM ubuntu:18.10

MAINTAINER Aritz <aritz@radixu.info>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
apt-get install -y apache2 


RUN apt-get update && \
apt-get install -y php libapache2-mod-php  \
php-fpm php-cli php-mysqlnd php-pgsql php-sqlite3 php-redis \
php-apcu php-intl php-mysql php-ldap php-imagick php-json php-gd php-curl && \
phpenmod ldap

RUN echo Europe/Madrid > /etc/timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

#ADD https://github.com/aritzz/radiocloud/archive/1.2.zip /var/www

RUN chown www-data:www-data /var/www/* -R

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
