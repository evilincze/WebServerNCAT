#!/bin/bash

if [[ "$#" -ne 1 ]]; then
	echo "Invalid number or arguments. Intended usage listener <port>"
	exit 1
fi

ncat -l "$1" --keep-open --exec ./server.sh
