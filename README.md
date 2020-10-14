Web development platform which drived by docker-composer

## How to use

* [docker-compose docs](https://docs.docker.com/compose/)

* Start service
`docker-compose up -d [--force-recreate] [--build] [service]`

## Configuration

* .env
You should create a .env file in this project root, which Define all envrionments used by docker-compose.yml.
Everything need to know please referer to env-example file.

## Directory structure

* docker-compose.yml
[Compose file version 3 reference](https://docs.docker.com/compose/compose-file/)

* containers
Accommodates containers definiation. Each sub-folder represent a service build context.
