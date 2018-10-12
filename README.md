#### Note

- Ubuntu 16.04 with nodebrew, git, build-essential, python.
- Mount current HOST Path to Container /mnt/host.
- Default expose HOST=33333 to Container=3333 Port of TCP.
- Python Docker add cronjob, rsyslog for create logfile.

#### Issue shooting

- If apt-get update --fix-missing cause error. Please docker images then remove old images and install again.
- Docker-compose's `entrypoint`  若有修改要讓他保持在 Blocking 狀態避免 Container exit.( default: /bin/bash, 如有修改可以最後加上這個 )
- 有關更新系統 cache 或是系統資料再執行相關指令的動作必須, 同一個 Container Stage 完成! 即 `apt-get update --fix-missing && apt-get install ...`.(因為有些系統檔案會被 Reset, 例如 /etc/hosts 會在每一個 Building Stage Container 重置)

#### Remote X-Window Application Launch Sample

- This container should be executed on GUI base Ubuntu System or others compatible OS.

```
$ docker-compose -f docker-compose-chromium.yml up
  ... or
$ docker-compose -f docker-compose-firefox.yml up
```

#### Dynamical Mapping PORT

```
ubuntu1604nvmdev:
    ...
  ports:
    - "${HPORT}:${CPORT}"
```

- Linux

```
$ HPORT=3333 docker-compose -f docker-compose-nginx.yml up -d
```

- Windows


```
> set HPORT=33333
> set CPORT=3333
> docker-compose -f docker-compose-nvm.yml up -d
```

#### Usage

![Alt text](https://raw.githubusercontent.com/scott1028/develop-env-on-docker/master/launch-container-for-dev-usage.png "launch-container-for-dev-usage.png")

- build(If you modify dockerfile, docker-compose.yml)

```
docker-compose build
```

- create

```
HPORT=33333 CPORT=3333 docker-compose up -d
	...
HPORT=33333 CPORT=3333 docker-compose up -d --build  # when update docker-compose.yml config
```

- stop

```
HPORT=33333 CPORT=3333 docker-compose stop
```

- remove

```
HPORT=33333 CPORT=3333 docker-compose rm
```

#### More

- Link File or Folder in docker-compose.yml

```
	...
  volumes:
    - ./:/mnt/host
    - ./README.md:/root/README.md
    ...
```

- Set docker-compose.yml file

```
HPORT=33333 CPORT=3333 docker-compose -f docker-compose-python.yml build
HPORT=33333 CPORT=3333 docker-compose -f docker-compose-python.yml up -d
```

- For Copy Container File Link to Host(ex: nginx, apache, Note: 如果發現 Build 不起來可以參考以下指令)

```
HPORT=33333 CPORT=3333 docker-compose -f docker-compose-apache.yml up -d --force-recreate --build
    ...
HPORT=33333 CPORT=3333 docker-compose -f docker-compose-nginx.yml up -d --force-recreate --build
    --force-recreate: override last build.
    --build: if Dockerfile change.
```

- ENTRYPOINT in Dockerfile & docker-compose.yaml 差別在於 Docker-Compose HOST 已 Mount Path。

#### Docker-Composer Init Command

![Alt text](https://raw.githubusercontent.com/scott1028/develop-env-on-docker/master/docker-compose-init-command.png "docker-compose-init-command")

#### Nginx Resolv Issue

![Alt text](https://raw.githubusercontent.com/scott1028/develop-env-on-docker/master/nginx-resolve-issue.png "nginx-resolve-issue.png")

```
location ~ ^/api/(.*)$ {
    resolver    8.8.8.8;
    proxy_pass  https://example.com/api/$1$is_args$query_string;
    proxy_pass_request_headers  on;
}
```

```
location /wsapp/ {
    proxy_pass http://wsbackend;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}
```

#### Set Reference to HOST IP in Container

```
$ ip route show 0.0.0.0/0 | grep -Eo 'via \S+' | awk '{ print $2"  dockerhost" }' >> /etc/hosts
```

```
# In docker-compose.yml
echo `ip route show 0.0.0.0/0 | grep -Eo 'via \S+' | awk '{ print $$2 }'`  dockerhost >> /etc/hosts;
```

### Remove Docker Images, Networks, Volumes, Remote 完全注意事項

* P.S 皆為安全移除已建立存在的 Container 相關 Image, Network, Volume 的不會被刪除！

- docker image list 必須清除

```
$ docker rmi $(docker image ls -q)
```

- docker network list 必須清除

```
$ docker network rm $(docker network ls -q)
```

- docker volume list 必須清除

```
$ docker volume rm $(docker volume ls -q)
```

### Apply auto restart when container crash

```
docker start <container>
docker update <container> --restart=always
    ... login container and kill entrypoint process id to simulate crash.
```

- By docker-compose.yml
- Ref: https://docs.docker.com/compose/compose-file/#restart

```
	...
   restart: always
   ports:
     - "33333:3333"
	...
```

- Simulate docker container crash

![Alt text](https://raw.githubusercontent.com/scott1028/develop-env-on-docker/master/simulate-docker-container-crash.png "simulate-docker-container-crash.png")

### For MySQL Restart( Avoid pid lock )

```
Entrypoint: rm -rf /run/mysqld; ...
```

- Build from Custom Image with docker-compose-dev.yml(base on squashed image of docker-compose.yml)

```
docker-compose -f docker-compose-dev.yml up -d
```

### Docker-Compose with passing parameter in *.yaml File

```
TD_AGENT_CONFIG=td-agent.conf docker-compose up -d --force-recreate
```

```
  ...
    entrypoint:
      - td-agent
      - "-c"
      - "/etc/td-agent/host/${TD_AGENT_CONFIG}"
  ...
```

### Docker Build Google Chrome Stable & Xvfb Builtin Image

```
docker build -f ./Dockerfile-google-chrome-stable .
```
