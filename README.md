[![Build Status](https://travis-ci.com/Otus-DevOps-2020-02/vdaishi_microservices.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2020-02/vdaishi_microservices)

# Vdaishi_microservices
Vdaishi microservices repository

# Docker контейнеры. Docker под капотом
- Основы Docker
- Создание docker host
- Создание своего образа
- Работа с Docker Hub
### Основы Docker

Для работы данного задания требуются:

- Docker - 17.06+
- docker-compose - 1.14+
- docker-machine -0.12.0+


Основные команды

- `docker version`  - информация о версии docker client и server
- `docker info` - Информаци о текущем состоянии docker daemon
- `docker run <image_id/image_name>` - команда `run` создает и запускает контейнер из `image` (`docker run` = `docker create` + `docker start` + `docker attach`* ) (`docker attach` только при наличии опции `-i`)
- `docker run -rm <image_id/image_name>` - команда `run` создает и запускает контейнер из `image` и оставляет контейнер вместе с содержимым на диске
- `docker images` - список сохраненных образов
- `docker ps` - список запущенных контейнеров
- `docker ps -a` - список всех контейнеров
- `docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Names}}" ` - Слегка переделанных формат вывода данных о контейнерах (ID образ дата создания и название)
- `docker start <container_id/container_name>` - запуск контейнера
- `docker attach <container_id/container_name>` - подключение терминала к данному контейнеру
- `docker create <image_id/image_name>` - создание контейнера из образа
- `docker exec <container_id> <app_name>` - запускает новый процесс внутри контейнера
- `docker commit <container_id> yourname` - создание образа из контейнера, при этом контейнер остается запущенным
- `docker inspect <image_id/container_id>` - вывод информации об образе/контейнере
- `docker kill <container_id>` - безусловное завершение контейнера
- `docker stop <container_id>` - остановка контейнера, в случае, если в течение 10 секунд он не останавливается, то безусловно завершается
- `docker kill $(docker ps -q)` - завершение всех контейнеров
- `docker system df` - Информация об объемах дискового пространства, занимаемого образами контейнерами и разделами, показывает сколько их них не используется и возможно удалить
- `docker rm <container_id>` - удаляет контейнер. (с флагом `-f` удаляет запущенный контейнер)
- `docker rmi <image_id>` - удаляет образ с флагом  `-f` удаляет запущенные контейнеры созданные на основе этого образа)

### Создание docker-host на основе GCE

`docker-machine` - встроенный в докер инструмент для создания хостов и установки на них `docker engine`. Имеет поддержку облаков и систем виртуализации (Virtualbox, GCP и др.)
- `docker-machine create <имя>` - Создание машины
- `eval $(docker-machine env <имя>)` - переключение между машинами
- `eval $(docker-machine env --unset)` - переключение на локальный докер
-  `docker-machine rm <имя>.` - Удаление  машины (с флагом `-f` удаляет в любом случае)
- docker-machine создает хост для докер демона со указываемым образом в `--googlemachine-image`, в ДЗиспользуется ubuntu-16.04. Образы которые используются дляпостроения докер контейнеров к этому никак не относятся.
- Все докер команды, которые запускаются в той же консоли после `eval $(docker-machine env <имя>)` работают с указанным докер демоном.

```zsh
export GOOGLE_PROJECT=<project_name>

 docker-machine create --driver google \
 --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntuos-cloud/global/images/family/ubuntu-1604-lts \
 --google-machine-type n1-standard-1 \
 --google-zone europe-west1-b \
 docker-host
 ```

- Запуск докермашины в GCP
`docker-machine ls` - список запущенных машин

### Создание своего образа приложения

Для создания образа нашего приложения потребуется четыре следующих файла
`Dockerfile` - текстовое описание нашего образа
`mongod.conf ` - подготовленный конфиг для mongodb
`db_config` - содержит переменную окружения со ссылкой на mongodb
`start.sh` -  скрипт запуска приложения

#### Команды dockerfile

`FROM ubuntu:16.04` - какой первоначальный образ использовать для создания контейнера
```dockerfile
RUN apt-get update
RUN apt-get install -y mongodb-server ruby-full ruby-dev build-essential git
RUN gem install bundler
...
```
- Запуск команд в контейнере
```
COPY mongod.conf /etc/mongod.conf
COPY db_config /reddit/db_config
COPY start.sh /start.sh
```
- Копирование файлов конфигураци в контейнер
`CMD ["/start.sh"]` - старт сервиса при старте контейнера
`docker build -t <container_name:Tag_name> .` -создание  контейнера. флаг `-t` задает тег для собранного образа. `.` в конце команды обязательна, она указывает на путь docker-контекста

### Docker Hub

`Docker Hub` Это обрачный сервих где хранятся контейнеры и оттуда по умолчанию скачивает образы docker.

Чтобы заливать туда свои конфиги надо создать там аккаунт а потом произвести авторизацию на компьютере.
`docker login` - авторизация в `Docker Hub`
`docker tag reddit:latest <your-login>/otus-reddit:1.0` - создание образа
`docker push <your-login>/otus-reddit:1.0` - заливка образа на `Docker Hub`

### Задание со *

В рамках задания была создана конфигурация terraform ansible packer для запуска приложения при помощи docker.
