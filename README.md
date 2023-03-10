### Мои скрипты автоматизации Puppet

```bash
wget https://alicorn.tk/zaebis.sh
chmod +x zaebis.sh
sudo ./zaebis.sh science
```

`zaebis.sh` с ключами `server` или `desktop` запускает Puppet для моих личных десктопных или серверных конфигураций. Тестирование проводилось на Debian 11, Ubuntu 22.10 и ArchLinux (+Manjaro).

Ключ `test` в качестве второго параметра игнорирует обновление репозитория через `git pull`

Включаем basic auth для Nginx: `sudo htpasswd -c /etc/nginx/.htpasswd username`

### Пакеты в AUR в дополнение к репозиторию

JHelioviewer 4 (пререлиз): <https://aur.archlinux.org/packages/jhelioviewer4-bin/>

GDL 1.0: <https://aur.archlinux.org/packages/gnudatalanguage-gdlkernel/>

### Debian-пакеты

JHelioviewer 4 (пререлиз): <http://swhv.oma.be/download_test/>

### Будущие доработки и текущие проблемы:

- **Больше примочек для Jupyter**
    - Хранилище готовых конфигов JupyterLab

- **Хочу скрипты настройки Android**
    - Решение: [fdroidcl](https://github.com/mvdan/fdroidcl) + экспорт избранных в Aurora Store
    - MyAppList, Neobackup, App Manager

- **Eyecandy**
    - Fira Sans и Fira Mono в deb-based дистрибутивах

- Хочу везде запустить crontab-скрипт раз в 3 дня, который удаляет скриншоты и загрузки

- Puppet не хочет ставить Python-модуль для graphviz, потому что его название совпадает с пакетом в репозитории. Проблема не критичная, возможно пофиксить в будущем или забить на неё и ставить вручную

- Хочу модуль FUSE для APFS (libfsapfs-utils)

- Хочу свои любимые шрифты и OnlyOffice в десктоп-пакете

- в KDE-конфигурациях надо подумать насчёт предустановки GUI для настройки планшетов Wacom (kcm-wacomtablet), plasma-browser-integration и plasma-pa
