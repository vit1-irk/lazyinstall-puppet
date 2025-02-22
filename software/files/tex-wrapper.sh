#!/bin/bash

# export HTTPS_PROXY=socks5://proxy.huecker.io:443

compose_string="services:
    mylatex:
        image: leplusorg/latex
        container_name: mylatex
        volumes:
            - \$HOME:\$HOME
            - /mnt/data:/mnt/data
        tty: true
        stdin_open: true
"

if [[ $(docker inspect -f '{{.State.Running}}' 'mylatex') != "true" ]]; then
    echo "starting docker compose";
    echo "$compose_string" | docker compose -f - up -d
fi

docker exec -w $PWD -i mylatex $@
