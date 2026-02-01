#!/usr/bin/env bash

get_info_ftb() {
	parts="$1"
	parts="${parts#*/v1/*/modpack/}"
	parts="${parts%/server*}"
	IFS='/' read -r id version <<< "$parts"
	echo "$id $version"
}

download_server() {
	echo "running setup"
	if [[ "$SERVER_TYPE" == "FTB" ]]; then

		wget -q -O setup "$DOWNLOAD_URL"
		chmod +x setup
	
		read -r id version <<< $(get_info_ftb $DOWNLOAD_URL)
		./setup -auto -force -pack "$id" -version "$version"
		if (( $? != 0 )); then
			echo "setup not done, use variable SERVER_SETUP_ARGS instead"
			exit 1
		fi

	elif [[ -v SERVER_SETUP_ARGS ]]; then

		wget -q -O setup "$DOWNLOAD_URL"
		chmod +x setup
		./setup $SERVER_SETUP_ARGS

	else

		wget -q -O "$SERVER_NAME" "$DOWNLOAD_URL"
		chmod +x "$SERVER_NAME"
	fi

	echo "finished setup"
}

run_server() {
	echo "creating server files"
	mkfifo minecraft-input.pipe minecraft-output.pipe
	$RUN_COMMAND < minecraft-input.pipe > minecraft-output.pipe &
	
	exec 3> minecraft-input.pipe
	
	while read -r line; do
		echo "$line"
		if echo "$line" | grep Done > /dev/null 2>&1; then
			echo "stop" > minecraft-input.pipe
		fi
	done < minecraft-output.pipe
	
	rm minecraft-input.pipe minecraft-output.pipe
	echo "finished creating server files"
}

main() {
	. scripts/functions.sh
	if [[ -v DOWNLOAD_URL ]]; then
		download_server
	fi
	run_server
}

main
