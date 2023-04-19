class software::desktop {
    $user = 'vitya'

    $pkgs_common = ['bleachbit', 'davfs2', 'ntfs-3g', 'qbittorrent', 'dosfstools', 'exfatprogs', 'gucharmap', 'gvfs', 'kde-cli-tools', 'kdeconnect', 'geany', 'modemmanager', 'mpv', 'os-prober', 'parted', 'gparted', 'pavucontrol', 'fatresize', 'pcmanfm-qt', 'udisks2', 'usbutils', 'telegram-desktop', 'yt-dlp', 'zenity', 'zip', 'squashfs-tools', 'syncthing', 'keepassxc', 'debootstrap', 'okular', 'f2fs-tools', 'gimp', 'remmina', 'mtpaint', 'powertop', 'refind', 'shadowsocks-libev', 'simplescreenrecorder', 'seahorse', 'thunderbird', 'tor', 'torsocks', 'translate-shell', 'onboard', 'qt5ct', 'materia-gtk-theme', 'papirus-icon-theme', 'grsync']

    $pkgs_debbased = ['fdisk', 'gdisk', 'gvfs-fuse', 'wpasupplicant', 'x11-utils', 'xinit', 'nextcloud-desktop', 'bluez-tools', 'go-mtpfs', 'gstreamer1.0-plugins-base', 'gstreamer1.0-plugins-good', 'gstreamer1.0-pulseaudio', 'libgstreamer-plugins-bad1.0-0', 'proxychains', 'localepurge', 'libfsapfs1', 'libfsapfs-utils', 'broadcom-sta-dkms', 'fonts-firacode', 'x2goclient']

    $pkgs_arch = ['firefox', 'firefox-i18n-ru', 'arch-install-scripts', 'wpa_supplicant', 'xorg-xinit', 'nextcloud-client', 'bluez-utils', 'gst-libav', 'gst-plugins-bad', 'gst-plugins-base', 'gst-plugins-good', 'gst-plugins-ugly', 'gstreamer-vaapi', 'gvfs-mtp', 'broadcom-wl-dkms', 'discord', 'mtpfs', 'pacgraph', 'proxychains-ng', 'refind-drivers', 'thunderbird-i18n-ru', 'mypaint', 'ttf-fira-sans', 'ttf-fira-mono', 'ttf-fira-code']
    
    $pkgs_debian = ['bluez-firmware', 'firefox-esr', 'firefox-esr-l10n-ru', 'thunderbird-l10n-ru']
    $pkgs_ubuntu = ['firefox', 'firefox-locale-ru', 'thunderbird-locale-ru']
    
    $pkgs_uninst = ['mc', 'mousepad', 'leafpad', 'emacs', 'youtube-dl', 'transmission-gtk', 'vinagre']

    $pkgs_custom = $operatingsystem ? {
        debian => $pkgs_debbased,
        ubuntu => $pkgs_debbased,
        archlinux => $pkgs_arch,
        manjarolinux => $pkgs_arch
    }
    
    $pkgs_debflavor = $operatingsystem ? {
        debian => $pkgs_debian,
        ubuntu => $pkgs_ubuntu,
        default => []
    }

    package { $pkgs_common: ensure => "installed" }
    package { $pkgs_custom: ensure => "installed" }
    package { $pkgs_debflavor: ensure => "installed" }
    package { $pkgs_uninst: ensure => "absent" }

    service { 'Syncthing':
        name => "syncthing@$user",
        ensure => "running",
        enable => "true",
        require => Package['syncthing']
    }

    if $facts['boardmanufacturer'] == "Apple Inc." {
        # Touchpad and fan configs for Macbook Air (macfanctld and xf86-input-mtrack needed)

        file { '/etc/macfanctl.conf':
            ensure => present,
            content => file('software/macfanctl.conf'),
            mode => "0644"
        }

        #file { '/etc/X11/xorg.conf.d/10-mtrack.conf':
        #    ensure => present,
        #    content => file('software/10-mtrack.conf'),
        #    mode => "0644"
        #}
    }

    $icon = 'xdg-desktop-icon install --novendor /usr/share/applications'
    $all_path = '/usr/local/bin/:/usr/bin'

    file { "xdg bookmarks":
        path => "/home/$user/.config/gtk-3.0/bookmarks",
        content => "file:///home/$user/Nextcloud\nfile:///home/$user/Nextcloud/%D0%90%D0%B2%D1%82%D0%BE%D0%B7%D0%B0%D0%B3%D1%80%D1%83%D0%B7%D0%BA%D0%B0\nfile:///tmp",
        owner => $user,
        ensure => present    
    }

    $icons = ["firefox.desktop", "org.keepassxc.KeePassXC.desktop", "x2goclient.desktop", "telegramdesktop.desktop"]

    $icons.each |String $fname| {
        exec { $fname: path => $all_path,
            command => "$icon/$fname",
            environment => [ "HOME=/home/$user" ],
            user => $user
        }
    }

    archive { "/tmp/android-platform-tools.zip":
      source        => 'https://dl.google.com/android/repository/platform-tools-latest-linux.zip',
      extract       => true,
      extract_path  => '/opt',
      creates       => '/opt/platform-tools',
      cleanup       => true,
    } -> file { '/usr/bin/adb':
        ensure => 'link',
        target => '/opt/platform-tools/adb',
        force  => true,
        mode => "0755"
    }

    file { '/usr/bin/fdroidcl':
        ensure => present,
        mode => "0755",
        source => 'https://github.com/mvdan/fdroidcl/releases/download/v0.7.0/fdroidcl_v0.7.0_linux_amd64'
    }
}
