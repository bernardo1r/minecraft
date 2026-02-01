FROM alpine

ARG WORKDIR
WORKDIR "$WORKDIR"

COPY scripts/ scripts/

RUN apk update && apk upgrade && apk add openjdk21-jre-headless screen bash

ENTRYPOINT ["scripts/run.sh"]
