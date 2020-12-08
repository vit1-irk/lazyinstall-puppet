class software::yaourt {
  file { '/etc/pacman.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }
  
  file {'/etc/pacman.d/archlinuxfr.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => '[archlinuxfr]\nServer = http://repo.archlinux.fr/$arch',
    notify  => Exec['pacman_sync_yaourt'],
    require => File['/etc/pacman.conf']
  }

  exec {'pacman_sync_yaourt':
    refreshonly => 'true',
    user        => 'root',
    command     => '/usr/bin/pacman --noconfirm --sync --refresh yaourt',
    require     => File['/etc/pacman.d/archlinuxfr.conf']
  }
}