#! /bin/bash
# Создадим правило фаервола для Prometheus и Puma:
gcloud compute firewall-rules create prometheus-default --allow tcp:9090
gcloud compute firewall-rules create puma-default --allow tcp:9292
# Создадим Docker хост в GCE и настроим локальное окружение на работу с ним
export GOOGLE_PROJECT=docker-279821
docker-machine create --driver google \
 --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
 --google-machine-type n1-standard-1 \
 --google-zone europe-west1-b \
 docker-host

eval $(docker-machine env docker-host)
