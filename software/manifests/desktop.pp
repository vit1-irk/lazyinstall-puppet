class software::desktop {
	$pkgs_common = ['bleachbit', 'xfce4-screenshooter', 'davfs2', 'ntfs-3g', 'transmission-gtk', 'dosfstools', 'exfat-utils', 'gucharmap', 'gvfs', 'kde-cli-tools', 'kdeconnect', 'emacs', 'geany', 'modemmanager', 'mpv', 'os-prober', 'parted', 'gparted', 'pavucontrol', 'fatresize', 'pcmanfm', 'udisks2', 'usbutils', 'x2goclient', 'telegram-desktop', 'youtube-dl', 'zenity', 'zip', 'squashfs-tools', 'syncthing', 'keepassxc', 'audacious', 'debootstrap', 'okular', 'f2fs-tools', 'gimp', 'vinagre', 'mtpaint', 'powertop', 'refind', 'shadowsocks-libev', 'simplescreenrecorder', 'seahorse', 'thunderbird', 'tor', 'torsocks', 'translate-shell', 'onboard', 'xfburn', 'qt5ct']

	$pkgs_debbased = ['exfat-fuse', 'fdisk', 'gdisk', 'gvfs-fuse', 'wpasupplicant', 'x11-utils', 'xinit', 'nextcloud-desktop', 'android-tools-adb', 'bluez-tools', 'go-mtpfs', 'gstreamer1.0-plugins-base', 'gstreamer1.0-plugins-good', 'gstreamer1.0-pulseaudio', 'libgstreamer-plugins-bad1.0-0', 'proxychains', 'pulseaudio-module-bluetooth', 'localepurge', 'libfsapfs1', 'libfsapfs-utils', 'broadcom-sta-dkms']

	$pkgs_arch = ['firefox', 'firefox-i18n-ru', 'arch-install-scripts', 'wpa_supplicant', 'xorg-xinit', 'nextcloud-client', 'android-tools', 'bluez-utils', 'gst-libav', 'gst-plugins-bad', 'gst-plugins-base', 'gst-plugins-good', 'gst-plugins-ugly', 'gstreamer-vaapi', 'gvfs-mtp', 'broadcom-wl-dkms', 'discord', 'mtpfs', 'pacgraph', 'proxychains-ng', 'pulseaudio-bluetooth', 'refind-drivers', 'thunderbird-i18n-ru', 'mypaint']
    
    $pkgs_debian = ['bluez-firmware', 'firefox-esr', 'firefox-esr-l10n-ru', 'thunderbird-l10n-ru']
    $pkgs_ubuntu = ['firefox', 'firefox-locale-ru', 'thunderbird-locale-ru']
    
	$pkgs_uninst = ['mc', 'mousepad', 'leafpad']

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

    file { '/etc/xdg/autostart/nextcloud-client.desktop':
        ensure => present,
        content => file('software/nextcloud-client.desktop'),
        mode => "0644"
    }

    file { '/etc/xdg/autostart/kdeconnect-indicator.desktop':
        ensure => present,
        content => file('software/kdeconnect-indicator.desktop'),
        mode => "0644"
    }

    if $facts['boardmanufacturer'] == "Apple Inc." {
        # Touchpad and fan configs for Macbook Air (macfanctld and xf86-input-mtrack needed)

        file { '/etc/macfanctl.conf':
            ensure => present,
            content => file('software/macfanctl.conf'),
            mode => "0644"
        }

        file { '/etc/X11/xorg.conf.d/10-mtrack.conf':
            ensure => present,
            content => file('software/10-mtrack.conf'),
            mode => "0644"
        }
    }
}
