#!/bin/bash
# Деплой личных SSH-настроек. Секреты (SSH_KEY, SSH_USER) берутся из
# ssh-info.env (не в git) через sops exec-env.

set -e

sops exec-env ./ssh-info.env "/opt/pyinfra/bin/pyinfra @local deploy/personal.py"
