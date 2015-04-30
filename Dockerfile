FROM node:0.10-onbuild

MAINTAINER paulodiovani

# install netcat
RUN apt-get -qq update \
    && apt-get -qq --force-yes install netcat-openbsd

# start only when mongo is available
CMD until nc -z "$MONGO_PORT_27017_TCP_ADDR" "$MONGO_PORT_27017_TCP_PORT"; do \
        echo 'waiting for mongo...'; \
        sleep 1; \
    done; \
    npm start

EXPOSE 3000
EXPOSE 3030
