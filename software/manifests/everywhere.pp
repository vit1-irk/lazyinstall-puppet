class software::everywhere {
    class { 'timezone': timezone => 'Asia/Irkutsk'}
    class { 'locales':
        default_locale  => 'ru_RU.UTF-8',
        locales         => ['en_US.UTF-8 UTF-8', 'ru_RU.UTF-8 UTF-8'],
    }

    # non-free repo is needed to install broadcom wifi drivers and unrar
    case $facts['os']['name'] { 'Debian': { 
    if $facts['dmi']['manufacturer'] != 'Hetzner' {
        if $facts['os']['distro']['codename'] == 'buster' {
            file { '/etc/apt/sources.list.d/mybackport.list':
                ensure => present,
                content => "deb http://deb.debian.org/debian buster-backports main contrib non-free\ndeb http://deb.debian.org/debian buster contrib non-free",
                mode => "0755"
            } -> exec { 'Update package list': command  => '/usr/bin/apt update' }
        }}
    } 'Archlinux': {
        include software::archlinuxcn
    }}

    $pkgs_common = ['vim', 'git', 'curl', 'bash-completion', 'busybox', 'diffutils', 'dkms', 'elinks', 'file', 'findutils', 'gdb', 'graphicsmagick', 'grep', 'moreutils', 'ncdu', 'nmap', 'p7zip', 'parallel', 'patch', 'pciutils', 'rsync', 'screen', 'sed', 'sshfs', 'sudo', 'unzip', 'wget', 'wireguard-dkms', 'wireguard-tools', 'ethtool', 'fdupes', 'iftop', 'iotop', 'lshw', 'lsof', 'zsh', 'unrar', 'qrencode']
    $pkgs_deb = ['adduser', 'apt-utils', 'apt-transport-https', 'build-essential', 'cron', 'openssh-client', 'openssh-server', 'openssh-sftp-server', 'python3-pip', 'wireguard', 'xz-utils', 'apt-file', 'wcalc', 'resolvconf']
    $pkgs_arch = ['base-devel', 'cronie', 'openssh', 'python-pip', 'xz', 'calc', 'yay']

    $pkgs_uninst = ['yaourt']

    $pkgs_custom = $operatingsystem ? {
        debian => $pkgs_deb,
        ubuntu => $pkgs_deb,
        archlinux => $pkgs_arch,
        manjarolinux => $pkgs_arch
    }

    package { $pkgs_common: ensure => "present" }
    package { $pkgs_custom: ensure => "present" }
    package { $pkgs_uninst: ensure => "absent" }
    
    file { '/usr/bin/easy-wg-quick':
        ensure => present,
        mode => "0755",
        source => 'https://raw.githubusercontent.com/burghardt/easy-wg-quick/master/easy-wg-quick'
    }

    if $facts['dmi']['board']['product'] == "M3A" {
        file { '/etc/systemd/system/m3a-usbfix.service':
            ensure => present,
            mode => "0644",
            content => file('software/m3a-usbfix.service')
        }
        service { 'm3a-usbfix':
            name => "m3a-usbfix",
            ensure => "running",
            enable => "true",
            require => File['/etc/systemd/system/m3a-usbfix.service']
        }
    }
}
