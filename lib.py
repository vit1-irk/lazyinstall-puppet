"""Общие константы и определение дистрибутива (по /etc/os-release)."""

from pyinfra import host
from pyinfra.facts.server import Command, OsRelease

USER = "vitya"
TIMEZONE = "Asia/Irkutsk"
LOCALES = ["en_US.UTF-8", "zh_CN.UTF-8", "ru_RU.UTF-8"]  # последний = LANG по умолчанию
DEFAULT_LANG = LOCALES[-1]
SOPS_URL = "https://github.com/mozilla/sops/releases/download/v3.7.3/sops-v3.7.3.linux.amd64"


def distro_flags():
    """(arch, debian, ubuntu, deb, codename) — флаги по /etc/os-release."""
    osr = host.get_fact(OsRelease)
    dist = osr.get("id", "")
    like = osr.get("id_like", "")
    return {
        "arch": dist == "arch" or "arch" in like,
        "debian": dist == "debian",
        "ubuntu": dist == "ubuntu",
        "deb": dist in ("debian", "ubuntu") or "debian" in like,
        "codename": osr.get("version_codename", "stable"),
    }


def nonfree_repo_missing():
    """True, если в apt-источниках ещё нет non-free-firmware."""
    return not host.get_fact(
        Command,
        command="grep -hE 'deb .* non-free-firmware' /etc/apt/sources.list /etc/apt/sources.list.d/*",
        _ignore_errors=True,
    )
