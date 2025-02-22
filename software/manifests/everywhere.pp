class software::everywhere {
    class { 'timezone': timezone => 'Asia/Irkutsk'}
    class { 'locales':
        default_locale  => 'ru_RU.UTF-8',
        locales         => ['en_US.UTF-8 UTF-8', 'ru_RU.UTF-8 UTF-8']
    }
    class { 'resolv_conf':
        nameservers => ['8.8.8.8', '1.1.1.1']
    }

    $user = 'vitya'

    user { $user:
        name => $user,
        ensure => present,
        managehome => "true",
        shell => "/bin/zsh",
        require => Package["zsh"]
    }

    group { "sudo group":
        name => "sudo",
        ensure => present
    }

    exec { "add user to group":
        command => "/sbin/usermod -a -G sudo $user",
        require => [User[$user], Group["sudo"]]
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

    $pkgs_common = ['vim', 'git', 'curl', 'bash-completion', 'busybox', 'diffutils', 'autossh', 'dkms', 'elinks', 'file', 'findutils', 'gdb', 'graphicsmagick', 'grep', 'moreutils', 'ncdu', 'nmap', 'p7zip', 'patch', 'pciutils', 'rsync', 'screen', 'sed', 'sshfs', 'sudo', 'unzip', 'wget', 'ethtool', 'fdupes', 'iftop', 'iotop', 'lshw', 'lsof', 'zsh', 'unrar', 'qrencode', 'net-tools']
    $pkgs_deb = ['adduser', 'apt-utils', 'apt-transport-https', 'build-essential', 'cron', 'openssh-client', 'openssh-server', 'openssh-sftp-server', 'python3-pip', 'xz-utils', 'apt-file', 'wcalc']
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

    file { '/usr/bin/checkmemory.sh':
        ensure => present,
        mode => "0755",
        content => file('software/checkmemory.sh')
    }
    
    file { '/usr/bin/sops':
        ensure => present,
        mode => "0755",
        source => 'https://github.com/mozilla/sops/releases/download/v3.7.3/sops-v3.7.3.linux.amd64'
    }
}
