class software::desktop {
	# fonts are questionable, office, libfsapfs-utils, mypaint
    # zsh config?
    # onlyoffice-desktopeditors
    # plasma-browser-integration, plasma-pa, kcm-wacomtablet
	# camptocamp-systemd puppet module

	$pkgs_common = ['bleachbit', 'xfce4-screenshooter', 'davfs2', 'ntfs-3g', 'transmission-gtk', 'dosfstools', 'exfat-utils', 'fdisk', 'gdisk', 'gucharmap', 'gvfs', 'gvfs-fuse', 'kde-cli-tools', 'kdeconnect', 'emacs', 'mousepad', 'localepurge', 'modemmanager', 'mpv', 'os-prober', 'parted', 'gparted', 'pavucontrol', 'fatresize', 'pcmanfm', 'udisks2', 'usbutils', 'x2goclient', 'youtube-dl', 'zenity', 'zip', 'squashfs-tools', 'syncthing', 'audacious', 'debootstrap', 'okular', 'f2fs-tools', 'gimp', 'vinagre', 'mtpaint', 'powertop', 'refind', 'shadowsocks-libev', 'simplescreenrecorder', 'thunderbird', 'tor', 'torsocks', 'translate-shell', 'onboard', 'xfburn', 'qt5ct']
    
	$pkgs_debbased = ['exfat-fuse',  'wpasupplicant', 'x11-utils', 'xinit', 'nextcloud-desktop', 'android-tools-adb', 'bluez-firmware', 'bluez-tools', 'go-mtpfs', 'gstreamer1.0-plugins-base', 'gstreamer1.0-plugins-good', 'gstreamer1.0-pulseaudio', 'libgstreamer-plugins-bad1.0-0', 'proxychains', 'pulseaudio-module-bluetooth', 'thunderbird-l10n-ru', 'libfsapfs1', 'libfsapfs-utils', 'broadcom-sta-dkms']
	$pkgs_arch = ['exfatprogs', 'firefox', 'firefox-i18n-ru', 'archiso', 'arch-install-scripts', 'git-man', 'wpa_supplicant', 'xorg-xinit', 'nextcloud-client', 'android-tools', 'bluez-utils', 'gst-libav', 'gst-plugins-bad', 'gst-plugins-base', 'gst-plugins-good', 'gst-plugins-ugly', 'gstreamer-vaapi', 'gvfs-mtp', 'broadcom-wl-dkms', 'discord', 'mtpfs', 'pacgraph', 'proxychains-ng', 'pulseaudio-bluetooth', 'refind-drivers', 'thunderbird-i18n-ru', 'mypaint']
    
    $pkgs_debian = ['firefox-esr', 'firefox-esr-l10n-ru']
    $pkgs_ubuntu = ['firefox', 'firefox-locale-ru']
    
	$pkgs_uninst = ['mc']

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
}