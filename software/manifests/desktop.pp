class software::desktop {
	# fonts are questionable, gstreamer plugins, office
	# camptocamp-systemd

	$pkgs_common = ['bleachbit', 'xfce4-screenshooter', 'davfs2', 'ntfs-3g', 'transmission-gtk', 'dosfstools', 'exfat-utils', 'fdisk', 'gdisk', 'gucharmap', 'gvfs', 'gvfs-fuse', 'kde-cli-tools', 'kdeconnect', 'emacs', 'mousepad', 'localepurge', 'modemmanager', 'mpv', 'os-prober', 'parted', 'gparted', 'pavucontrol', 'fatresize', 'pcmanfm', 'udisks2', 'usbutils', 'x2goclient', 'youtube-dl', 'zenity', 'zip', 'squashfs-tools', 'syncthing']
    
	$pkgs_debbased = ['exfat-fuse',  'wpasupplicant', 'x11-utils', 'xinit', 'nextcloud-desktop']
	$pkgs_arch = ['exfatprogs', 'firefox', 'firefox-i18n-ru', 'archiso', 'arch-install-scripts', 'git-man', 'wpa_supplicant', 'xorg-xinit', 'nextcloud-client']
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