class software::personal {
    $user = 'vitya'

    ssh_authorized_key { 'empty2':
        ensure => present,
        user   => $user,
        type   => 'ssh-rsa',
        key    => 'empty1'
    }

    $ssh_service_name = $operatingsystem ? {
        debian => "ssh",
        ubuntu => "ssh",
        archlinux => "sshd",
        manjarolinux => "sshd"
    }

    #service { 'ssh':
    #    name => $ssh_service_name,
    #    ensure => "running",
    #    enable => "true"
    #}

    class { 'ssh::server':
      validate_sshd_file => true,  
      options => {
        'Match User www-data' => {
          'ChrootDirectory' => '%h',
          'ForceCommand' => 'internal-sftp',
          'PasswordAuthentication' => 'no',
          'AllowTcpForwarding' => 'no',
          'X11Forwarding' => 'no',
        },
        'Match User vitya' => {
          'PasswordAuthentication' => 'yes',
          'AllowTcpForwarding' => 'yes',
          'X11Forwarding' => 'yes',
        },
        'PrintMotd'              => 'no',
        'StreamLocalBindUnlink'  => 'yes',
        'PasswordAuthentication' => 'yes',
        'PermitRootLogin'        => 'no',
        'Port'                   => 356,
      }
    }
}