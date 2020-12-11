class software::archlinuxcn {
  file_line { 'pacmanconf':
    ensure  => present,
    line    => 'Include = /etc/pacman.d/archlinuxcn.conf',
    path    => '/etc/pacman.conf',
    append_on_no_match => true
  }

  file {'/etc/pacman.d/archlinuxcn.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "[archlinuxcn]\nServer = http://repo.archlinuxcn.org/\$arch",
    notify  => Exec['pacman_sync']
  }

  exec {'pacman_sync':
    refreshonly => 'true',
    user        => 'root',
    command     => '/usr/bin/pacman --noconfirm --sync --refresh archlinuxcn-keyring',
    subscribe   => [File_Line['pacmanconf'], File['/etc/pacman.d/archlinuxcn.conf']]
  }
}