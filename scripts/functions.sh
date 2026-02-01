#!/usr/bin/env bash

if [[ ! -v SERVER_NAME ]]; then
	SERVER_NAME="server.jar"
fi

if [[ ! -v RUN_COMMAND ]]; then
	RUN_COMMAND="java -jar ${SERVER_NAME} nogui"
fi

if [[ "$SERVER_TYPE" == "FTB" ]];then
	RUN_COMMAND="./run.sh"
fi
