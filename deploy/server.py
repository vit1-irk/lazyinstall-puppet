"""Сервер: docker, мониторинг, fail2ban, бэкап PostgreSQL. Включает base.

Запуск (от root):  pyinfra @local deploy/server.py
"""

from pyinfra import local
from pyinfra.operations import apt, files, server
from lib import USER, distro_flags

local.include("deploy/base.py")

F = distro_flags()

if F["deb"]:
    apt.packages(
        name="Server packages",
        packages=["apache2-utils", "fail2ban", "prometheus-node-exporter", "tcpdump"],
        update=True,
        cache_time=3600,
    )
    apt.packages(name="Remove apache2-bin", packages=["apache2-bin"], present=False)
    apt.packages(
        name="Docker",
        packages=["docker.io", "docker-compose", "docker-compose-plugin"],
        latest=True,
    )

server.user(name=f"{USER} in docker group", user=USER, groups=["docker"], append=True)

files.put(
    name="PostgreSQL backup script",
    src="files/backup-pg.sh",
    dest="/usr/bin/backup-pg.sh",
    mode="755",
)
