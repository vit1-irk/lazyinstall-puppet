class software::everywhere {
	$pkgs_common = ['vim', 'git', 'curl', 'bash-completion', 'busybox', 'diffutils', 'dkms', 'elinks', 'file', 'findutils', 'gdb', 'graphicsmagick', 'grep', 'moreutils', 'ncdu', 'nmap', 'p7zip', 'parallel', 'patch', 'pciutils', 'rsync', 'screen', 'sed', 'sshfs', 'sudo', 'unzip', 'wget', 'wireguard-dkms', 'wireguard-tools']
	$pkgs_deb = ['adduser', 'apt-utils', 'apt-transport-https', 'build-essential', 'cron', 'openssh-client', 'openssh-server', 'openssh-sftp-server', 'python3-pip', 'wireguard', 'xz-utils']
	$pkgs_arch = ['base-devel', 'cronie', 'openssh', 'python-pip', 'xz']

	$pkgs_uninst = ['mc']

	$pkgs_custom = $operatingsystem ? {
		debian => $pkgs_deb,
		ubuntu => $pkgs_deb,
		archlinux => $pkgs_arch,
		manjarolinux => $pkgs_arch
	}

	package { $pkgs_common: ensure => "installed" }
	package { $pkgs_custom: ensure => "installed" }
	package { $pkgs_uninst: ensure => "absent" }
}

class software::desktop {
	# fonts are questionable, gstreamer plugins, office
	# camptocamp-systemd

	$pkgs_common = ['bleachbit', 'xfce4-screenshooter', 'davfs2', 'ntfs-3g', 'transmission-gtk', 'dosfstools', 'exfat-utils', 'fdisk', 'gdisk', 'gucharmap', 'gvfs', 'gvfs-fuse', 'kde-cli-tools', 'kdeconnect', 'mousepad', 'localepurge', 'modemmanager', 'mpv', 'os-prober', 'parted', 'gparted', 'pavucontrol', 'fatresize', 'pcmanfm', 'udisks2', 'usbutils', 'x2goclient', 'youtube-dl', 'zenity', 'zip']
	$pkgs_deb = ['exfat-fuse', 'firefox-esr', 'firefox-esr-l10n-ru', 'wpasupplicant', 'x11-utils', 'xinit']
	$pkgs_arch = ['exfatprogs', 'firefox', 'firefox-i18n-ru', 'archiso', 'arch-install-scripts', 'git-man', 'wpa_supplicant', 'xorg-xinit']

	$pkgs_uninst = ['mc']

	$pkgs_custom = $operatingsystem ? {
		debian => $pkgs_deb,
		ubuntu => $pkgs_deb,
		archlinux => $pkgs_arch,
		manjarolinux => $pkgs_arch
	}

	package { $pkgs_common: ensure => "installed" }
	package { $pkgs_custom: ensure => "installed" }
	package { $pkgs_uninst: ensure => "absent" }
}

class software::server {
	$pkgs = ['letsencrypt', 'certbot', 'nginx', 'fail2ban']
	package { $pkgs: ensure => "installed"}
}

include software::everywhere
