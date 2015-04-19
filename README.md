[![Build Status](https://travis-ci.org/LazyParking/lazyparking-server.svg?branch=master)](https://travis-ci.org/LazyParking/lazyparking-server)

# lazyparking-server

The Server scripts for Lazy Park

## Dependencies

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
