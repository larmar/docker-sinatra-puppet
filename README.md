# Docker-sinatra-puppet

Docker specfile to create a ruby sinatra web server.
Sinatra webservice to update environment subdirectories
in puppet 

Ruby script to add environments in puppet via json github hook.

create Web hook in github project for push event http://hostname.example.com:4567/trigger-puppet.json

branch production should no be used. This environment is handled manually by checking out a specific tag. 
