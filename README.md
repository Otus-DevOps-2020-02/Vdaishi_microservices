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

# Образы Docker- Микросервисы

### Инструкции
Каждая команда является слоем образа, и занимает определенное пространство и доступно только для чтения, последний слой является итоговым и доступен для чтения и записи, который монтируется при запуске контейнера.

Инструкция `LABEL` задает метаданные для образа:

```docker
LABEL <key>=<value>
# <key> - ключ
# <value> - значение

# Пример

LABEL mainteiner - "user@examlpe.org version= "0.2.1-8d2095e3ce"
```

Инструкции `COPY` и `ADD` копируют файлы из контекста в образ:

```docker
COPY <src> [<src> ...] <dst>
# или
COPY ["<src>",... "<dest>"]
# <src> - файл или директория внутри build контекста
# <dst> - файл или директория внутри контейнера

# Пример

COPY start* /startup/
COPY httpd.conf magicfile /etc/httpd/conf/
```

```docker
ADD http://example.org/app.tar.xz /src/app/
RUN tar -xJf /usr/src/things/big.tar.xz -C /src/app
RUN make -C /usr/src/app all
RUN rm -f /usr/src/things/big.tar.xz
```

Отличие `COPY` и `ADD` :

- `Add` может скачивать данные по ссылке;
- `Add` умеет разархивировать архивы (данные из архива будут находится в образе) (`COPY` просто скопирует архив в образ);
  - Примечание: `ADD` умеет разархивировать не все архивы, а так же при скачивании архива, разархивирования не будет.

Инструкия `ENV` задает переменные окружения:

```docker
ENV <key> <value>
# <key> - имя переменной окружения
# <value> - присваиваемое значение

# Пример:

ENV LOG_LEVEL debug
ENV DB_HOST 127.0.0.1:3389
```

Инструкция `WORKDIR` задает рабочую директорию при сборке:

```docker
WORKDIR <path>
# <path> - путь внутри контейнера

# Пример:

WORKDIR /app
```

Инструкция `VOLUME` позволяе указать точки монтирования томов внутри образа

```docker
VOLUME <dst> [<dst> …]
# <dst> - директория монтирования для volume'а

# Пример

VOLUME /app /db /data
# или
VOLUME ["/var/www", "/var/log/apache2", "/etc/apache2"]
```

Инструкция `RUN` задает команды которые выполняются при сборке контейнера

```docker
RUN <command>
# <command> - команда которая будет выполнена при создании образа

#Примеры:

RUN apt-get update && apt-get install nginx
RUN ["bash", "-c", "rm", "-rf", "/tmp/abc"]
RUN ["myscript.py", "argument1","argument2"]
```

Инструкция `CMD` задает команду, которая выполняется при
старте контейнера:`

```docker
CMD <command>
# <command> - команда которая будет выполнена при старте контейнера

#Примеры:

CMD /start.sh
CMD ["echo", "Dockerfile CMD demo"]
```

Инструкция `ENTRYPOINT` задает команду, которая выполняется на **старте** контейнера

```docker
ENTRYPOINT <command>
# <command> - команда которая будет выполнена при старте контейнера
ENTRYPOINT exec top -b
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]
```

Дополнительные команды

```docker
ONBUILD <cmd>
# Задает команду, которая запускается при сборке образа на базе текущего
STOPSIGNAL <sig>
# Указывает сигнал, который посылается процессу при остановке контейнера
USER <username>
# Имя (ID) пользователя, от которого выполняются директивы RUN, CMD, ENTRYPOINT
ARG <string>
# Почти как ENV, но задает параметры только для docker build
HEALTHCHECK <cmd>
# Указывает команду, которой можно проверить состояние сервиса
```

Инструкции кэшируются в образах.

Для ускорения сборки и оптимизации образа порядок инструкций **ОЧЕНЬ ВАЖЕН**.

Пропустить и перестроить кэш можно командой

```zsh
docker build --no-cache
```

Команда, позволяющая собрать все слои в один (словно все инструкции были исполнены в одном слое)

```
docker build --squash
```
`Packer` собирает контейнеры `Docker` именно с данным параметром.

Минусы данного подхода:
- Слой один и может долго распаковываться или передаваться по сети (много слоев качаются параллельно)
- При сборке будет потрачено гораздо больше места (все промежуточные слои + итоговый слой)

# Задания со *

Уменьшен размер образов, переходом на alpine, мспробован запуск контейнер с другими сетевыми алиасами

# Практика Docker сети docker-compose

В данной работе следует учесть необходимость последовательности команд при работе с двумя сетями , иначе веб интерфейс не сможет достучаться до контейнеров `post` и `comment`

Имя при запуске проекта получается из имени папки, в которой находится проект.

Так же можно задать его в `.env `файле в переменной `COMPOSE_PROJECT_NAME`

# Практика Gitlab-CI

Для работы образа `gitlab-ci` понадобится машина со следующими параметрами
- 1 CPU
- 3.75GB RAM
- 50-100 GB HDD
- Ubuntu 16.04

В работе мы будем использовать omnibus установку, которая позволит быстро запустить сервис.

Параметры образа расположены в файле `gitlab-ci/docker-compose.yml`

Раннеры у нас прописываются в файле `.gitlab-ci.yml`

для работы с нашим `Gitlab` в репозитории требуется выполнить команду

```
git remote add gitlab http://<your-vm-ip>/homework/example.git
```

для создания раннера в докере необходимы команды

```
docker run -d --name gitlab-runner --restart always \
-v /srv/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest
```

После запуска раннера, требуется его зарегистрировать (Токен можно получить в настройках раннера)

```
docker exec -it gitlab-runner gitlab-runner register --run-untagged --locked=false
```


# Введение в мониторинг

#### План:
- Prometheus: запуск, конфигурация, знакомство с Web UI
- Мониторинг состояния микросервисов
- Сбор метрик хоста с использованием экспортера


В рамках данной работы используется образ `prometheus` `prom\prometheus:v2.1.0`.
Образ Prometheus собирается из папки `monitoring\prometheus`. Конфигурация мониторинга указывается в файле prometheus.yml

Для запуска используется `docker-compose`.

Мониторинг осуществляется доступностью портов сервисов, а так же при помощи `Node-exporter`

после развертывания prometheus будет доступен на порту `9000`
# Мониторинг приложенияи инфраструктуры

#### План:
- Мониторинг Docker контейнеров
- Визуализация метрик
- Сбор метрик работы приложения и бизнес метрик
- Настройка и проверка алертинга
- Много заданий со ⭐ (необязательных)

Мониторинг Dockth контейнеров можно осуществить с помощью `cAdvisor`:
  примерами метрик являются:
  - процент использования контейнером CPU и памяти, выделенные для его запуска,
  - объем сетевого трафика

Для работы с `cAdvisor` добавлен сервис в наш `docker-compose-monitor.yml` и добавили его в prometheus.

Для визуализации метрик используется `Grafana`.
Указывая источником данных наш Prometheus, мы можем получить всю информацию о наших метриках в одном дашборде.

В рамках работы были созданы 3 дашборда: `Business_logic_Monitoring` `DockerMonitoring` `UI_Service_Monitoring`


Для информирования об алертах в нашей системе, используется `AlertManager`

Создав конфигурацию алертов , в случае наступления алерт-случаев, нам отправляется сообщение в `Slack`.

Так же Alertmanager может отправлять сообщения на почту.

# Логирование и распределенная трассировка

#### План

- Сбор неструктурированных логов
- Визуализация логов
- Сбор структурированных логов
- Распределенная трасировка

Для централизации хранения логов в с наших контейнеров, одним из вариантов являеся использование Elastic стека (ELK) (ElasticSearch, Logstash, Kibana)

в данной работе используется вместо Logstash Fluentd

Kibana используется для визуализации логов и их поиска с помощью ElasticSearch

В случае, если логи структурированые Fluentd их отправит напрямую в Elasticsearch, иначе нам необходимо написать либо регулярное выражение самостоятельно, либо использовать grok-шаблоны.

Zipkin используется для распределенного трейсинга нашего сервиса, позволяя обнаружить проблемы в нашем сервисе, на каждом его этапе

В задании со звездочкой мы обнаруживаем, что наш сервис отвечает около 3 секунд, связано это с тем, что указан таймер в коде приложения в 3 сек `time.sleep(3)`

# Введение в Kubernetes

Это вводная работа. Изучен туториал по развертыванию кластера Kubernetes The Hard Way

С учетом ограничений GCP на 4 IP то было изменено количество контроллеров и воркеров с 3 до 2.

# Kubernetes. Запуск кластера и приложения. Модель безопасности.

#### План

- Развернуть локальное окружение для работы с Kubernetes
- Развернуть Kubernetes в GKE
- Запустить reddit в Kubernetes


Основными инсрументами при работе с Kubernetes является Kubectl или для Openshift oc

Основные команды

`kubectl apply -f ./` - развертывание всех конфигураций в каталоге в Kubernetes

`minikube start` - инсталляция локального kkubernetes

`kubectl get pods` - проверка наших подов

`kubectl delete -f ./` - удаление всех наших конфигураций, описанных в каталоге из Kubernetes

Развернуть Kubernetes в GCP можно с помощью Terraform (что и было сделано), либо с помощью веб интерфейса

чтобы подключиться к Kubernetes GCP необходимо получить команду из веб интерфейса вида :
`$ gcloud container clusters get-credentials cluster-1 --zone us-central1-a --project docker-182408`


Так же наше приложение было описано и развернуто в Kubernetes.
