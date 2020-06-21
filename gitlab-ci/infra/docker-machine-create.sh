#!/bin/bash
#Указываем свой проект в гугл
export GOOGLE_PROJECT=docker-279821
#Создаем машину docker (правило доступа по 2376 порту будет создано автоматически)
docker-machine create --driver google \
  --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
  --google-machine-type n1-standard-1 \
  --google-zone europe-west4-a \
  docker-host

# создаем правило доступа к порту приложения
gcloud compute firewall-rules create puma-http --allow=tcp:9292

# Подключаем консоль докера к данной машине
eval $(docker-machine env docker-host)
