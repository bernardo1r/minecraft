#!/usr/bin/env bash

setup_dns() {
	echo "nameserver 8.8.8.8" > /etc/resolv.conf
}

install_uv() {
	curl -LsSf https://astral.sh/uv/install.sh | sh
	. ~/.profile
}

remove_uv() {
	uv cache clean
	rm -r "$(uv python dir)"
	rm -r "$(uv tool dir)"
	rm -r .venv
}

download_modrinth() {
	curl -L "$DOWNLOAD_URL" > cobbleverse.zip
	
	apk add unzip
	unzip cobbleverse.zip
	apk del unzip
	
	mv overrides/* .
	rm -r overrides cobbleverse.zip
	
	curl -L "$DOWNLOAD_SERVER_URL" > server.jar

	install_uv
	uv run python scripts/install-mods.py
	remove_uv
}

get_ftb_mod_info() {
	local parts id version
	parts="$1"
	parts="${parts#*/v1/*/modpack/}"
	parts="${parts%/server*}"
	IFS='/' read -r id version <<< "$parts"
	echo "$id $version"
}

download_ftb() {
	local id version
	curl -L "$DOWNLOAD_URL" > setup
	chmod +x setup

	read -r id version <<< $(get_ftb_mod_info "$DOWNLOAD_URL")
	./setup -auto -force -pack "$id" -version "$version"
	if (( $? != 0 )); then
		echo "setup not done, use variable SERVER_SETUP_ARGS instead"
		exit 1
	fi

	echo -n "$RUN_COMMAND_ARGS" > user_jvm_args.txt
}

download_vanilla() {
	curl -L "$DOWNLOAD_URL" > server.jar
}

main() {
	setup_dns

	if [[ "$SERVER_TYPE" == "FTB" ]]; then
		download_ftb
	elif [[ "$SERVER_TYPE" == "MODRINTH" ]]; then
		download_modrinth
	else
		download_vanilla
	fi
	
	if [[ "$EULA" == "true" ]]; then
		echo -n "eula=true" > eula.txt
		exit 0
	else
		exit 1
	fi
}

main
