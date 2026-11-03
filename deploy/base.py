"""Базовая система: время, локали, DNS, пользователь, общие пакеты, sops, archlinuxcn.

Запуск (из корня репозитория, от root):  pyinfra @local deploy/base.py
"""

from pyinfra.operations import apt, files, pacman, server
from lib import LOCALES, SOPS_URL, TIMEZONE, USER, DEFAULT_LANG, distro_flags, nonfree_repo_missing

F = distro_flags()

# --- Время ---
server.timezone(name=f"Timezone {TIMEZONE}", timezone=TIMEZONE)

# --- Локали: пакет locales, строки в /etc/locale.gen, LANG по умолчанию ---
if F["deb"]:
    apt.packages(name="Install locales package", packages=["locales"], update=True, cache_time=3600)
elif F["arch"]:
    pacman.packages(name="Install locales package", packages=["locales"], update=True)

for locale in LOCALES:
    files.line(
        name=f"Enable locale {locale}",
        path="/etc/locale.gen",
        line=f"^{locale} UTF-8$",
    )

server.shell(name="Regenerate locales", commands=["locale-gen"])

files.line(
    name=f"Default LANG={DEFAULT_LANG}",
    path="/etc/default/locale" if F["deb"] else "/etc/locale.conf",
    line=f"LANG={DEFAULT_LANG}",
)

# --- DNS ---
for nameserver in ("nameserver 8.8.8.8", "nameserver 1.1.1.1"):
    files.line(name=nameserver, path="/etc/resolv.conf", line=nameserver)

# --- Пользователь ---
server.group(name="Ensure sudo group", group="sudo")
server.user(
    name=f"Ensure user {USER} with zsh",
    user=USER,
    shell="/usr/bin/zsh",
    groups=["sudo"],
    append=True,
)

# --- Debian: репозиторий non-free-firmware ---
if F["debian"] and nonfree_repo_missing():
    apt.repo(
        name="Add non-free-firmware repository",
        src=f"deb http://deb.debian.org/debian/ {F['codename']} main contrib non-free non-free-firmware",
    )

# --- Общие пакеты ---
COMMON_PACKAGES = [
    "autossh",
    "bash-completion",
    "busybox",
    "curl",
    "diffutils",
    "dkms",
    "elinks",
    "ethtool",
    "fdupes",
    "file",
    "findutils",
    "gdb",
    "git",
    "graphicsmagick",
    "grep",
    "iftop",
    "iotop",
    "lshw",
    "lsof",
    "moreutils",
    "ncdu",
    "net-tools",
    "nmap",
    "patch",
    "pciutils",
    "qrencode",
    "rsync",
    "screen",
    "sed",
    "sshfs",
    "sudo",
    "unrar",
    "unzip",
    "vim",
    "wget",
    "zsh",
]

if F["deb"]:
    apt.packages(name="Common packages", packages=COMMON_PACKAGES, update=True, cache_time=3600)
    apt.packages(
        name="Common packages (Debian-based)",
        packages=[
            "adduser",
            "apt-file",
            "apt-transport-https",
            "apt-utils",
            "build-essential",
            "cron",
            "openssh-client",
            "openssh-server",
            "openssh-sftp-server",
            "p7zip-full",
            "wcalc",
        ],
    )
elif F["arch"]:
    pacman.packages(name="Common packages", packages=COMMON_PACKAGES, update=True)
    pacman.packages(
        name="Common packages (Arch)",
        packages=[
            "base-devel",
            "calc",
            "cronie",
            "openssh",
            "p7zip",
            "xz",
            "yay",
            "zsh-completions",
        ],
    )
else:
    server.packages(name="Common packages", packages=COMMON_PACKAGES)

# --- sops (бинарник для шифрованных секретов) ---
files.download(name="Install sops", src=SOPS_URL, dest="/usr/bin/sops", mode="755")

# --- Arch: репозиторий archlinuxcn ---
if F["arch"]:
    files.line(
        name="Include archlinuxcn.conf in pacman.conf",
        path="/etc/pacman.conf",
        line="Include = /etc/pacman.d/archlinuxcn.conf",
    )
    files.put(
        name="ArchLinuxCN repository config",
        src="files/archlinuxcn.conf",
        dest="/etc/pacman.d/archlinuxcn.conf",
        mode="644",
    )
    server.shell(name="Sync ArchLinuxCN keyring", commands=["pacman --noconfirm -Sy archlinuxcn-keyring"])
