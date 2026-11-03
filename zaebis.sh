#!/bin/bash
# Мои скрипты автоматизации (pyinfra).
# Использование: sudo ./zaebis.sh {base|desktop|server|science|personal}
# Второй параметр "test" — не делать git pull.

set -e

if [ "$(id -u)" != 0 ]; then
    echo "you need to be root"
    exit 1
fi
source /etc/profile

VENV=/opt/pyinfra
if [ ! -x "$VENV/bin/pyinfra" ]; then
    if command -v apt-get > /dev/null; then
        apt-get -y install git python3-venv
    elif command -v pacman > /dev/null; then
        pacman -Sy --needed --noconfirm git
    fi
    python3 -m venv "$VENV"
    "$VENV/bin/pip" install --upgrade pyinfra
fi

if [ ! -d ".git" ]; then
    echo "we are not inside git repo, clone and CD"
    git clone https://github.com/vit1-irk/lazyinstall-puppet
    cd lazyinstall-puppet
fi

if [ "$2" != "test" ]; then
    git pull
fi

PYINFRA="$VENV/bin/pyinfra"

case "$1" in
    base)     exec "$PYINFRA" @local deploy/base.py ;;
    desktop)  exec "$PYINFRA" @local deploy/desktop.py ;;
    server)   exec "$PYINFRA" @local deploy/server.py ;;
    science)  exec "$PYINFRA" @local deploy/science.py ;;
    personal) exec ./sensitive.sh ;;
    *)        echo "usage: sudo ./zaebis.sh {base|desktop|server|science|personal} [test]"; exit 1 ;;
esac
