#!/bin/bash

cmd_replace='sed "s|empty1|$SSH_KEY|g; s|empty2|$SSH_USER|g" software/manifests/personaltpl.pp > software/manifests/personal.pp'

sops exec-env ./ssh-info.env "$cmd_replace"