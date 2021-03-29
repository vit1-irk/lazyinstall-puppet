### Мои скрипты автоматизации Puppet

```bash
wget https://ii-net.tk/zaebis.sh
chmod +x zaebis.sh
sudo ./zaebis.sh science
```

`zaebis.sh` с ключами `server` или `desktop` запускает Puppet для моих личных десктопных или серверных конфигураций. Тестирование проводилось на Debian Buster (10), Ubuntu 20.10 и ArchLinux (+Manjaro).

### Пакеты в AUR в дополнение к репозиторию

JHelioviewer 4 (пререлиз): <https://aur.archlinux.org/packages/jhelioviewer4-bin/>

GDL 1.0: <https://aur.archlinux.org/packages/gnudatalanguage-gdlkernel/>

### Debian-пакеты

JHelioviewer 4 (пререлиз): <http://swhv.oma.be/download_test/>

### Будущие доработки и текущие проблемы:

- **Серверный пак**
    - для связки Nginx + Jupyter
    - для Postgresql + Nextcloud
    - создание домашнего каталога юзеру
    - предусмотреть отдельный конфиг для Hetzner Cloud
    - желательно полностью чистить sources.list на Debian (за исключением Hetzner)

- **Больше примочек для Jupyter**
    - Хранилище готовых конфигов JupyterLab
    - [LaTeX для Jupyter](https://github.com/jupyterlab/jupyterlab-latex)

- **Хочу скрипты настройки Android**
    - Решение: [fdroidcl](https://github.com/mvdan/fdroidcl) + экспорт избранных в Aurora Store
    - OandBackupX?

- Хочу везде запустить crontab-скрипт раз в 3 дня, который удаляет скриншоты и загрузки
- В matplotlib 3.2 есть баг, который не позволяет нормально строить графики с временными рядами. Решение: используем matplotlib 3.1.2. Но по-хорошему надо связаться с разработчиками или подождать свежего релиза

- GDL-kernel в Арче работает только в отдельном окне (проблема не решена)

- Puppet не хочет ставить Python-модуль для graphviz, потому что его название совпадает с пакетом в репозитории. Проблема не критичная, возможно пофиксить в будущем или забить на неё и ставить вручную

- в Debian MyPaint и GIMP конфликтуют. Не критично, но всё же проблема

- Хочу модуль FUSE для APFS (libfsapfs-utils)

- Хочу свои любимые шрифты и OnlyOffice в десктоп-пакете

- в KDE-конфигурациях надо подумать насчёт предустановки GUI для настройки планшетов Wacom (kcm-wacomtablet), plasma-browser-integration и plasma-pa

- Полный переход на ZSH
