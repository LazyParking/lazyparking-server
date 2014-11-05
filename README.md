# lazyparking-server

The Server scripts for Lazy Park

## Install and running

1. First, install [Node.js](http://nodejs.org)
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
sending some `JSON` data.