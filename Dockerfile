FROM larmar/ubuntu:latest
MAINTAINER martin.wilderoth@gmail.com

RUN \
  apt-get update \
  && apt-get install -y ruby-sinatra thin \
  && apt-get install -y git \
  && rm -rf /var/lib/apt/lists/*

ADD trigger.rb /
RUN chmod 755 trigger.rb

VOLUME ["/etc/puppet/environments"]

EXPOSE 4567

CMD /trigger.rb
