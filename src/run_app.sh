docker network create reddit
docker run -d --network=reddit --network-alias=post_db \
--network-alias=comment_db -v reddit_db:/data/db mongo:latest
docker run -d --network=reddit --network-alias=post vdaishi/post:1.1
docker run -d --network=reddit --network-alias=comment vdaishi/comment:2.0
docker run -d --network=reddit -p 9292:9292 vdaishi/ui:2.0
