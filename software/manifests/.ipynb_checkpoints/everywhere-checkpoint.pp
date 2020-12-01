class software::everywhere {
	$pkgs_common = ['vim', 'git', 'curl', 'bash-completion', 'busybox', 'diffutils', 'dkms', 'elinks', 'file', 'findutils', 'gdb', 'graphicsmagick', 'grep', 'moreutils', 'ncdu', 'nmap', 'p7zip', 'parallel', 'patch', 'pciutils', 'rsync', 'screen', 'sed', 'sshfs', 'sudo', 'unzip', 'wget', 'wireguard-dkms', 'wireguard-tools']
	$pkgs_deb = ['adduser', 'apt-utils', 'apt-transport-https', 'build-essential', 'cron', 'openssh-client', 'openssh-server', 'openssh-sftp-server', 'python3-pip', 'wireguard', 'xz-utils', 'apt-file']
	$pkgs_arch = ['base-devel', 'cronie', 'openssh', 'python-pip', 'xz']

	$pkgs_uninst = []

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