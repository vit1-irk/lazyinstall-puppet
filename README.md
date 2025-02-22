### Мои скрипты автоматизации Puppet

```bash
chmod +x zaebis.sh
sudo ./zaebis.sh science
```

Ключ `test` в качестве второго параметра игнорирует обновление репозитория через `git pull`

Включаем basic auth для Nginx: `sudo htpasswd -c /etc/nginx/.htpasswd username`

### Пакеты в дополнение к репозиторию

* JHelioviewer 4 (AUR): <https://aur.archlinux.org/packages/jhelioviewer4/>
* JHelioviewer 4 (Debian): <http://swhv.oma.be/download_test/>

### Будущие доработки и текущие проблемы:

- **Больше примочек для Jupyter**
    - Хранилище готовых конфигов JupyterLab

- **Хочу скрипты настройки Android**
    - Решение: [fdroidcl](https://github.com/mvdan/fdroidcl) + экспорт избранных в Aurora Store
    - MyAppList, Neobackup, App Manager

- Хочу везде запустить crontab-скрипт раз в 3 дня, который удаляет скриншоты и загрузки

- Хочу свои любимые шрифты и OnlyOffice в десктоп-пакете

- в KDE-конфигурациях надо подумать насчёт предустановки GUI для настройки планшетов Wacom (kcm-wacomtablet), plasma-browser-integration и plasma-pa
