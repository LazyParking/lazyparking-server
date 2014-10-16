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

## Testing the echo serve

Until now, the only thing that the server does is to echo every message received.

You can try it with any application that can connect to a Socks Server. Even with telnet.

    telnet localhost 3030
