#!/usr/bin/env bash

SETUP_DONE=false
STATUS=0

info() {
	echo "$@" >&2
}

dump_env() {
	echo "$SETUP_DONE" > .env
	echo "$STATUS" >> .env
}

load_env() {
	if [[ ! -f .env ]]; then
		return
	fi

	{
		read -r SETUP_DONE
		read -r STATUS
	} < .env
}

check_status() {
	STATUS=$?
	if (( $STATUS != 0 )); then
		dump_env
		info "$@"
		exit $STATUS
	fi
}

setup() {
	info "starting setup"

	scripts/add-eula.sh
	check_status "failed to add eula config"

	scripts/create-server-files.sh
	check_status "failed to create server files"

	scripts/change-server-properties.sh
	check_status "failed to change config"

	info "setup done"
	SETUP_DONE=true
	dump_env
}

stop() {
	screen -S server -X "/stop\n"
}

run() {
	if [[ ! -v SERVER_NAME ]]; then
		SERVER_NAME="server.jar"
	fi

	if [[ "$SERVER_TYPE" == "FTB" ]]; then
		RUN_COMMAND="./run.sh"

	elif [[ ! -v RUN_COMMAND ]]; then
		RUN_COMMAND="java -jar ${SERVER_NAME} nogui"
	fi
	screen -dmS server $RUN_COMMAND
	
	while screen -ls server > /dev/null 2>&1; do
		sleep 1
	done
}

main() {
	load_env
	if (( $STATUS != 0 )); then
		exit $STATUS
	fi

	if [[ "$SETUP_DONE" != "true" ]]; then
		setup
	fi

	trap stop TERM EXIT INT

	info "starting server"
	run &
	wait $!
	info "closing server"
}

main
