FROM larmar/ubuntu:latest
MAINTAINER martin.wilderoth@gmail.com

apt-get update \
&& apt-get install -y ruby-sinatra thin \
&& rm -rf /var/lib/apt/lists/*
