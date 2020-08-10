docker network create back_net --subnet=10.0.2.0/24
docker network create front_net --subnet=10.0.1.0/24
docker run -d --network=back_net --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=back_net  --network-alias=post --name=post vdaishi/post:1.1
docker network connect front_net post
docker run -d --network=back_net  --network-alias=comment --name=comment vdaishi/comment:2.0
docker network connect front_net comment
docker run -d --network=front_net -p 9292:9292 vdaishi/ui:2.0
