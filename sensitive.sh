#!/bin/bash

cmd_replace='sed "s|empty1|$SSH_KEY|g; s|empty2|$SSH_USER|g" playbooks/personal.yaml > playbooks/personal1.yaml'

sops exec-env ./ssh-info.env "$cmd_replace"
