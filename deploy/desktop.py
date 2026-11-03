"""Десктоп: мультимедиа, утилиты, Android platform-tools. Включает base.

Запуск (от root):  pyinfra @local deploy/desktop.py
"""

from pyinfra import local
from pyinfra.operations import apt, files, pacman, server
from lib import distro_flags

local.include("deploy/base.py")

F = distro_flags()

DESKTOP_PACKAGES = [
    "bleachbit",
    "btop",
    "davfs2",
    "debootstrap",
    "dosfstools",
    "exfatprogs",
    "fatresize",
    "f2fs-tools",
    "geany",
    "gimp",
    "grsync",
    "gvfs",
    "keepassxc",
    "modemmanager",
    "mpv",
    "mtpaint",
    "ntfs-3g",
    "os-prober",
    "parted",
    "qbittorrent",
    "remmina",
    "seahorse",
    "squashfs-tools",
    "telegram-desktop",
    "thunderbird",
    "tor",
    "torsocks",
    "translate-shell",
    "udisks2",
    "usbutils",
    "yt-dlp",
    "zip",
]

DEB_DESKTOP_PACKAGES = [
    "bluez-tools",
    "broadcom-sta-dkms",
    "fonts-firacode",
    "gdisk",
    "fdisk",
    "go-mtpfs",
    "gvfs-fuse",
    "localepurge",
    "nextcloud-desktop",
    "proxychains",
    "wpasupplicant",
]

ARCH_DESKTOP_PACKAGES = [
    "arch-install-scripts",
    "bluez-utils",
    "broadcom-wl-dkms",
    "discord",
    "firefox",
    "firefox-i18n-ru",
    "gvfs-mtp",
    "mtpfs",
    "nextcloud-client",
    "pacgraph",
    "proxychains-ng",
    "rnote",
    "thunderbird-i18n-ru",
    "ttf-fira-code",
    "ttf-fira-mono",
    "ttf-fira-sans",
    "wpa_supplicant",
    "xournalpp",
]

if F["deb"]:
    apt.packages(name="Desktop packages", packages=DESKTOP_PACKAGES, update=True, cache_time=3600)
    apt.packages(name="Desktop packages (Debian-based)", packages=DEB_DESKTOP_PACKAGES)
elif F["arch"]:
    pacman.packages(name="Desktop packages", packages=DESKTOP_PACKAGES, update=True)
    pacman.packages(name="Desktop packages (Arch)", packages=ARCH_DESKTOP_PACKAGES)

if F["debian"]:
    apt.packages(
        name="Desktop packages (Debian)",
        packages=["bluez-firmware", "firefox-esr", "firefox-esr-l10n-ru", "thunderbird-l10n-ru"],
    )
elif F["ubuntu"]:
    apt.packages(
        name="Desktop packages (Ubuntu)",
        packages=["firefox", "firefox-locale-ru", "thunderbird-locale-ru"],
    )

# --- Android platform-tools (adb): скачать, распаковать, симлинк ---
files.download(
    name="Download Android platform-tools",
    src="https://dl.google.com/android/repository/platform-tools-latest-linux.zip",
    dest="/tmp/platform-tools.zip",
    cache_time=604800,
)
files.unarchive(
    name="Extract Android platform-tools",
    src="/tmp/platform-tools.zip",
    dest="/opt",
    remote_src=True,
    creates="/opt/platform-tools",
)
files.link(
    name="Expose adb in PATH",
    path="/usr/bin/adb",
    target="/opt/platform-tools/adb",
    force=True,
)
