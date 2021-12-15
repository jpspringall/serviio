# Serviio docker
#
# VERSION               0.2
# Run with: docker run --rm --name serviio -d -p 23423:23423/tcp -p 8895:8895/tcp -p 1900:1900/udp riftbit/docker-serviio
# or        docker run --rm --name serviio -t -i -p 23423:23423/tcp -p 8895:8895/tcp -p 1900:1900/udp riftbit/docker-serviio

FROM debian:buster-slim
MAINTAINER James S

# Install Dependencies
RUN apt-get update && apt-get upgrade -y
	
RUN apt-get install -y wget nano ffmpeg x264 dcraw

RUN apt-get install -y --no-install-recommends openjdk-11-jre

RUN	mkdir -p ~/src

ARG SERVIIO_VERSION=2.2.1	

# Install Serviio
RUN cd ~/src && wget http://download.serviio.org/releases/serviio-${SERVIIO_VERSION}-linux.tar.gz && \
  tar -xvzf serviio-${SERVIIO_VERSION}-linux.tar.gz -C . && \
  mkdir -p /tmp && \
  mkdir -p /opt/serviio && \
  mkdir -p /opt/serviio/library && \
  mkdir -p /opt/serviio/plugins && \
  mkdir -p /opt/serviio/log && \
  mkdir -p /opt/serviio/config && \
  mv ./serviio-${SERVIIO_VERSION}/* /opt/serviio && \
  chmod +x /opt/serviio/bin/serviio.sh
  
RUN  rm -rf ~/src

#VOLUME ["/opt/serviio/library", "/opt/serviio/plugins", "/opt/serviio/log", "/opt/serviio/config", "/media", "/tmp"]

EXPOSE 1900/udp
EXPOSE 8895/tcp
# HTTP/1.1 /console /rest
EXPOSE 23423/tcp 
# HTTPS/1.1 /console /rest
EXPOSE 23523/tcp
# HTTP/1.1 /cds /mediabrowser
EXPOSE 23424/tcp
# HTTPS/1.1 /cds /mediabrowser
EXPOSE 23524/tcp

#HEALTHCHECK --start-period=5m CMD wget --quiet --tries=1 -O /dev/null --server-response --timeout=5 http://127.0.0.1:23423/console/ || exit 1

CMD tail -f /opt/serviio/log/serviio.log & /opt/serviio/bin/serviio.sh
