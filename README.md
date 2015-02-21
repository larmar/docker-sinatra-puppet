# Docker-sinatra-puppet

Create a Sinatra web-service that updates and maintain environments in a puppet server. Each branch is creating an environment that is available on the puppet server.

create Web hook in github project for push event http://hostname.example.com:4567/trigger-puppet.json

Branch production should no be used. This branch silently ignored.
The environment production should be handled manually on the puppet server if used. 

necessary keys needs to be created in /opt/data/ssh

##Run in docker
```
docker run -d -v /etc/puppet/environments:/etc/puppet/environments \
             -v /opt/data/ssh:/root/.ssh \
             -p 4567:4567 \
             larmar/sinatra-puppet
```
