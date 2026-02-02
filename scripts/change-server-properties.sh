#!/usr/bin/env bash

declare -A server_properties

read_properties() {
	local key value
	while IFS='=' read -r key value; do
		server_properties["$key"]="$value"
	done < server.properties
}

save_properties() {
	> server.properties
	local key
	for key in "${!server_properties[@]}"; do
		echo "${key}=${server_properties[$key]}" >> server.properties
	done
}

update_properties() {
	local name value
	local empty=false
	if (( ${#server_properties[@]} == 0 )); then
		empty=true
	fi

	while IFS='=' read -r name value; do
		name=$(echo "$name" | tr 'A-Z_' 'a-z-')
		if [[ -v server_properties["$name"] || "$empty" == "true" ]]; then
			server_properties["$name"]="$value"
		fi
	done <<< $(env)
}

echo "reading server properties"
read_properties

echo "changing values"
update_properties

echo "saving server properties"
save_properties
