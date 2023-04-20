#!/bin/bash

if [ $(docker inspect -f '{{.State.Running}}' "mylatex") != "true" ]; then
    echo "starting docker compose";
    docker compose -f /opt/latex-compose.yml up -d
fi

docker exec -w $PWD -i mylatex $@