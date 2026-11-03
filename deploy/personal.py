"""Личные настройки SSH: authorized_keys и sshd_config. Включает base.

Секреты (SSH_KEY, SSH_USER) приходят из ssh-info.env через `sops exec-env`,
поэтому запускают так:  ./sensitive.sh
"""

import os

from pyinfra import local
from pyinfra.operations import files, server
from lib import distro_flags

local.include("deploy/base.py")

F = distro_flags()

USER = os.environ.get("SSH_USER", "vitya")
SSH_KEY = os.environ.get("SSH_KEY")
SSHD_SERVICE = "ssh" if F["deb"] else "sshd"

if not SSH_KEY:
    raise RuntimeError("SSH_KEY не задан — запускайте через ./sensitive.sh (sops exec-env)")

server.user_authorized_keys(name=f"Authorized key for {USER}", user=USER, public_keys=[SSH_KEY])

# Строки sshd_config по порядку (Match-блок ограничивает scope до конца файла)
SSHD_CONFIG_LINES = [
    f"Match User {USER}",
    "  PasswordAuthentication yes",
    "  AllowTcpForwarding yes",
    "  X11Forwarding yes",
    "PrintMotd no",
    "StreamLocalBindUnlink yes",
    "PermitRootLogin no",
    "Port 356",
]

for line in SSHD_CONFIG_LINES:
    files.line(name=f"sshd_config: {line.strip()}", path="/etc/ssh/sshd_config", line=line.strip())

server.shell(name="Check sshd config syntax", commands=["sshd -t"])
server.service(name=f"{SSHD_SERVICE} enabled and running", service=SSHD_SERVICE, running=True, enabled=True)
server.service(name=f"Restart {SSHD_SERVICE}", service=SSHD_SERVICE, restarted=True)
