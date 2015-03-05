FROM debian:jessie
MAINTAINER aokinobu@gmail.com
RUN apt-get update && apt-get install -y squid3 telnet && rm -rf /var/lib/apt/lists/*
RUN mv /etc/squid3/squid.conf /etc/squid3/squid.conf.dist
ADD squid.conf /etc/squid3/squid.conf
ADD start /start
RUN chmod 755 /start
EXPOSE 3128
#RUN apt-get update && apt-get -y install telnet
VOLUME ["/var/spool/squid3"]
CMD ["/start"]
