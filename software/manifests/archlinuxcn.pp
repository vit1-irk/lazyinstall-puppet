class software::archlinuxcn {
  file { '/etc/pacman.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file_line {'cnrepo':
    ensure  => present,
    line => "[archlinuxcn]\nServer = http://repo.archlinuxcn.org/\$arch",
    notify  => Exec['pacman_sync'],
    path    => '/etc/pacman.conf'
  }

  exec {'pacman_sync':
    refreshonly => 'true',
    user        => 'root',
    command     => '/usr/bin/pacman --noconfirm --sync --refresh archlinuxcn-keyring',
    require     => File_Line['cnrepo']
  }
}