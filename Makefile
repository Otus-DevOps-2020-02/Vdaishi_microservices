# defaults
user = vdaishi
export USER_NAME = $(user)

default : build_all push_all
app_make:build_app push_app
monitoring_make: build_monitoring push_monitoring
# Builds

build_all: build_app build_monitoring

build_app: build_ui build_comment build_post

build_monitoring: build_prometheus build_alertmanager

## Builds for app

build_ui:
	@echo Building UI
	docker build -t $(user)/ui ./src/ui
build_comment:
	@echo Building comment
	docker build -t $(user)/comment ./src/comment

build_post:
	@echo Building post
	docker build -t $(user)/post ./src/post-py

## builds for monitoring

build_prometheus:
	@echo Building prometheus
	docker build -t $(user)/prometheus ./monitoring/prometheus

build_alertmanager:
	@echo Building alertmanager
	docker build -t $(user)/alertmanager ./monitoring/alertmanager

# Push in Docker Hub
push_all: push_app push_monitoring

push_app: push_ui push_comment push_post

push_monitoring: push_prometheus push_alertmanager

# Push for app

push_ui:
	@echo Push UI
	docker push $(user)/ui
push_comment:
	@echo Push comment
	docker push $(user)/comment

push_post:
	@echo Push post
	docker push $(user)/post

## Push for monitoring

push_prometheus:
	@echo Push prometheus
	docker push $(user)/prometheus

push_alertmanager:
	@echo Push alertmanager
	docker push $(user)/alertmanager
