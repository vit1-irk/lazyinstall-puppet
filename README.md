### Мои скрипты автоматизации (pyinfra)

```bash
chmod +x zaebis.sh
sudo ./zaebis.sh science
```

Всё ставится в venv `/opt/pyinfra`, pyinfra сам доустанавливает зависимости.
Ключ `test` в качестве второго параметра игнорирует обновление репозитория через `git pull`.

### Профили деплоя

| Профиль   | Файл              | Что делает                                              |
|-----------|-------------------|---------------------------------------------------------|
| `base`    | `deploy/base.py`  | время, локали, DNS, пользователь, общие пакеты, sops, archlinuxcn |
| `desktop` | `deploy/desktop.py` | base + десктоп-пакеты, Android platform-tools (adb)   |
| `server`  | `deploy/server.py`  | base + docker, fail2ban, prometheus, бэкап PostgreSQL  |
| `science` | `deploy/science.py` | base + DS9, LaTeX, Jupyter, python-стек               |
| `personal`| `deploy/personal.py`| base + SSH (authorized_keys, sshd_config) — только через `./sensitive.sh` |

Все профили включают `base.py`. Секреты (`SSH_KEY`, `SSH_USER`) лежат в
`ssh-info.env` (шифруется sops, не в git); `sensitive.sh` подставляет их
через `sops exec-env`.

Полезно: `pyinfra @local deploy/desktop.py --dry` — показать, что изменится, не меняя.

### Пакеты в дополнение к репозиторию

* JHelioviewer 4 (Debian): <http://swhv.oma.be/download_test/>
