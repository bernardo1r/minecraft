#!/usr/bin/env bash

echo "adding eula"

if [[ "$EULA" == "true" ]]; then
	echo -n "eula=true" > eula.txt
else
	echo "EULA variable is not true" >&2
	exit 1
fi
