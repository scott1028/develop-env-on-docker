#### Note

- Ubuntu 16.04 with nodebrew, git, build-essential.
- Mount current HOST Path to Container /mnt/host.
- Default expose HOST=33333 to Container=3333 Port of TCP.

#### Usage

- build(If you modify dockerfile, docker-compose.yml)

```
docker-compose build
```

- create

```
docker-compose up -d
```

- stop

```
docker-compose stop
```

- remove

```
docker-compose rm
```
