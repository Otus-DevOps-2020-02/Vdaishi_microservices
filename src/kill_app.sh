#! /bin/bash

docker kill $(docker ps -a -q)

docker network rm reddit front_net back_net

docker system prune --volumes -f
