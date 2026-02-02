FROM alpine
ARG WORKDIR
WORKDIR $WORKDIR

RUN apk update && apk upgrade
RUN apk add openjdk21-jre-headless bash screen curl

COPY . .

entrypoint ["scripts/run.sh"]
