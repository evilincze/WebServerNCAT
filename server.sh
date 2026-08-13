#!/bin/bash

printf "New connection %s\r\n" "$(date)" >&2

read -r method path version

##Path travelsal
ROOT="$(realpath ".")"
requested="$(realpath "$ROOT$path" 2>/dev/null)"
if [[ "$requested" != "$ROOT" && "$requested" != "$ROOT"/* ]]; then
    echo "Path traversal attempt: $path" >&2
    exit 0
fi

if [[ "$path" == "/" ]];then
	path="/index.html"
fi

if [[ -f ".$path" ]];then

    mime=$(file --brief --mime-type ".$path")
    size=$(stat -c%s ".$path")

    echo "Method: $method" >&2
    echo "Path: $path" >&2
    echo "Version: $version" >&2

    printf "HTTP/1.1 200 OK\r\n"
    printf "Content-Type: %s\r\n" "$mime"
    printf "Content-Length: %d\r\n" "$size"
    printf "Connection: close\r\n"
    printf "\r\n"
    cat ".$path"

else
    echo "Method: $method" >&2
    echo "Path: $path" >&2
    echo "File not found 404" >&2

    printf "HTTP/1.1 404 Not Found\r\n"
    printf "Content-Type: text/html\r\n"
    printf "Connection: close\r\n"
    printf "\r\n"
    printf "<h1>404 Not Found</h1>"
fi

echo "" >&2
