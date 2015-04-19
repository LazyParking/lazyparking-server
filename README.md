[![Build Status](https://travis-ci.org/LazyParking/lazyparking-server.svg?branch=master)](https://travis-ci.org/LazyParking/lazyparking-server)

# lazyparking-server

The Server scripts for Lazy Park

## Dependencies

### Running with Docker

* [Docker](docker.io)

  Windows and Mac OSX Users may be able to run with
  [boot2docker](http://boot2docker.io/) (requires VirtualBox).

* [Docker Compose](https://docs.docker.com/compose/)

See [Run with Docker](#run-with-docker)

### Running as a local server

* [Node.js](http://nodejs.org) `0.10`

* MongoDB
  
  By default, running on localhost on default port (`27017`) with
  blank username and password.

  Alternative configs should be provided through the folowing
  environment variables:

  - `MONGO_SERVER_ADDRESS`
  - `MONGO_PORT_NUMBER`
  - `MONGO_DB_USERNAME`
  - `MONGO_DB_PASSWORD`
  - `MONGO_DB_NAME`

## Install and running

1. Get the sources from GitHub
    
        git clone https://github.com/LazyParking/lazyparking-server.git

1. Go into the new directory and install dependencies (may take a while)

        cd lazyparking-server
        npm install

1. Run

        npm start

## Ports and services

### Express

By default, the express server run on port `3000`. 

You can acess http://localhost:3000 to reach the webpages.

### Drone/TCP

The _Drone_ communication service runs on port `3030`.

You can test it by connecting with `telnet localhost 3030` and 
sending some `JSON` data, or by running the util script
`util/flood.coffee`.

## Run with Docker

This repository provides a `Dockerfile` and a `docker-compose.yml`
for running the app on a Docker container, with a single command.

On the first run, just do:

    docker-compose up

The command may take a while, since it will download images, build
the app, install dependecies and start services. By default it runs
attached to terminal.

After the setup is complete, you can start/stop or check the
application logs with:

    # starts the containers detached from terminal
    docker-compose start

    # stops the unning containers
    docker-compose stop

    # check the container logs
    docker-compose logs
