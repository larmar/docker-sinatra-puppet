FROM larmar/ubuntu:latest
MAINTAINER martin.wilderoth@gmail.com

RUN \
  apt-get update \
  && apt-get install -y ruby-sinatra thin \
  && apt-get install -y git \
  && rm -rf /var/lib/apt/lists/*

ADD trigger.rb 

EXPOSE 4567
