FROM alpine

WORKDIR /server

COPY scripts/ scripts/

RUN apk update && apk upgrade && apk add openjdk21-jre-headless screen bash

ENTRYPOINT ["scripts/run.sh"]
