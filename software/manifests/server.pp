class software::server {
    $user = 'vitya'
    $pkgs = ['apache2-utils', 'letsencrypt', 'certbot', 'python3-certbot-nginx', 'nginx', 'fail2ban', 'emacs-nox', 'tcpdump', 'prometheus-node-exporter']
    $pkgs_uninst = ['apache2-bin']

    package { $pkgs: ensure => "installed" }
    package { $pkgs_uninst: ensure => "absent" }

    service { 'Nginx':
        name => "nginx",
        ensure => "running",
        enable => "true",
        require => Package['nginx']
    }

    file { '/etc/nginx/sites-enabled/jupyter.conf':
        ensure => present,
        content => epp('software/jupyter-nginx.conf'),
        mode => "0644",
        require => Package['nginx'],
        notify  => Service['Nginx']
    }

    file { '/etc/nginx/sites-enabled/default':
        ensure => present,
        content => file('software/nginx-default.conf'),
        mode => "0644",
        require => Package['nginx'],
        notify  => Service['Nginx']
    }

    file { '/etc/nginx/sites-enabled/exporter.conf':
        ensure => present,
        content => epp('software/prometheus-node-exporter-nginx.conf'),
        mode => "0644",
        require => [Package['nginx'], Package['prometheus-node-exporter']],
        notify  => Service['node-exporter']
    }

    service { 'node-exporter':
        name => "prometheus-node-exporter",
        ensure => "running",
        enable => "true",
        require => Package['prometheus-node-exporter']
    }
    
    class { 'docker':
        version => latest,
        docker_users => ['vitya']
    }
    ~> package { 'docker-compose-plugin': ensure => "installed" }
    ~> class {'docker::compose':
        ensure  => present,
        version => latest,
        require => Package['docker-compose-plugin']
    }
    
    file { '/etc/gitea':
        ensure => 'directory',
        owner  => $user,
        group  => 'root',
        mode   => '0754'
    }
    file { '/etc/gitea/docker-compose.yml':
        ensure => present,
        content => file('software/gitea-compose.yml'),
        mode => "0644",
        owner => $user,
        require => File['/etc/gitea']
    }
}
