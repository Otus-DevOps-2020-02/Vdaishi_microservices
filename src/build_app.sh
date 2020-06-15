docker pull mongo:latest
docker build -t vdaishi/post:1.1 ./post-py
docker build -t vdaishi/comment:2.0 ./comment
docker build -t vdaishi/ui:2.0 ./ui
