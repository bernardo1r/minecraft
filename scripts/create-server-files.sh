#!/usr/bin/env bash

mkfifo minecraft-input.pipe minecraft-output.pipe

get_info_ftb() {
	parts="$1"
	parts="${parts#*/v1/*/modpack/}"
	parts="${parts%/server*}"
	IFS='/' read -r id version <<< "$parts"
	echo "$id $version"
}

download_server() {
	if [[ ! -v SERVER_NAME ]]; then
		SERVER_NAME="server.jar"
	fi
	
	if [[ "$SERVER_TYPE" == "FTB" ]]; then
		echo "running setup"
	
		wget -q -O setup "$DOWNLOAD_URL"
		chmod +x setup
	
		read -r id version <<< $(get_info_ftb $DOWNLOAD_URL)
		./setup -auto -force -pack "$id" -version "$version"
		if (( $? != 0 )); then
			echo "setup not done user variable SERVER_SETUP_ARGS"
			exit 1
		fi
	
		echo "finished setup"
	elif [[ -v SERVER_SETUP_ARGS ]]; then
		echo "running setup"
	
		wget -q -O setup "$DOWNLOAD_URL"
		chmod +x setup
		./setup $SERVER_SETUP_ARGS
	
		echo "finished setup"
	else
		wget -q -O "$SERVER_NAME" "$DOWNLOAD_URL"
		chmod +x "$SERVER_NAME"
	fi
}

run_server() {
	if [[ "$SERVER_TYPE" == "FTB" ]];then
		RUN_COMMAND="./run.sh"
	elif [[ ! -v RUN_COMMAND ]]; then
		RUN_COMMAND="java -jar ${SERVER_NAME} nogui"
	fi
	
	echo "creating server files"
	$RUN_COMMAND < minecraft-input.pipe > minecraft-output.pipe &
	
	exec 3> minecraft-input.pipe
	
	while read -r line; do
		if echo "$line" | grep Done > /dev/null 2>&1 ; then
			echo "stop" > minecraft-input.pipe
		fi
	done < minecraft-output.pipe
	
	rm minecraft-input.pipe minecraft-output.pipe
	echo "finished creating server files"
}

main() {
	download_server
	run_server
}

main
