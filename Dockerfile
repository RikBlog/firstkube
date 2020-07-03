FROM ubuntu:latest
MAINTAINER Rik Blog 

# Install cron
RUN apt-get update && apt-get install -y cron 
RUN apt-get install -y nano

ENV TZ 'Europe/Amsterdam'
RUN echo $TZ > /etc/timezone
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y tzdata && \
  rm /etc/localtime && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata

# Add files
ADD run.sh /run.sh
ADD entrypoint.sh /entrypoint.sh
 
RUN chmod +x /run.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh