# defaults
user = vdaishi
export USERNAME = $(user)

default : build_all push_all

# Builds

build_ all: build_app build_monitoring

build_app: build_ui build_comment build_post

build_monitoring: build_prometheus

## Builds for app

build_ui:
	@echo Building UI
	docker build -t $(user)/ui ./src/ui
build_comment:
	@echo Building comment
	docker build -t $(user)/comment ./src/comment

build_post:
	@echo Building post
	docker build -t $(user)/post ./src/post

## builds for monitoring

build_prometheus:
	@echo Building prometheus
	docker build -t $(user)/prometheus ./monitoring/prometheus

# Push in Docker Hub
push_all: push_app push_monitoring

push_app: push_ui push_comment push_post

push_monitoring: push_prometheus

# Push for app

push_ui:
	@echo Push UI
	docker Push -t $(user)/ui
push_comment:
	@echo Push comment
	docker Push -t $(user)/comment

push_post:
	@echo Push post
	docker Push -t $(user)/post

## Push for monitoring

push_prometheus:
	@echo Push prometheus
	docker Push -t $(user)/prometheus
