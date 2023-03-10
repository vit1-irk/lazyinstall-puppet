class software::server {
    $user = 'vitya'
    $pkgs = ['apache2-utils', 'letsencrypt', 'certbot', 'python3-certbot-nginx', 'nginx', 'fail2ban', 'tcpdump', 'prometheus-node-exporter']
    $pkgs_uninst = ['apache2-bin']

    package { $pkgs: ensure => "installed" }
    package { $pkgs_uninst: ensure => "absent" }

    class { 'openssl':
        package_ensure         => latest,
        ca_certificates_ensure => latest
    }

    file { '/etc/ssl/localhost-self.cnf':
        ensure => present,
        content => epp('software/self-signed'),
        mode => "0644"
    }
    ssl_pkey { '/etc/ssl/private/localhost-self.key':
        ensure   => 'present'
    }
    x509_cert { '/etc/ssl/certs/localhost-self.crt':
        ensure      => 'present',
        template    => '/etc/ssl/localhost-self.cnf',
        private_key => '/etc/ssl/private/localhost-self.key',
        days        => 365,
        force       => false
    }

    $fqdn = $facts['networking']['fqdn']
    if find_file("/etc/letsencrypt/live/$fqdn") {
        $cert_file = "/etc/letsencrypt/live/$fqdn/fullchain.pem"
        $key_file = "/etc/letsencrypt/live/$fqdn/privkey.pem"
    } else {
        $cert_file = '/etc/ssl/certs/localhost-self.crt'
        $key_file = '/etc/ssl/private/localhost-self.key'
    }

    service { 'Nginx':
        name => "nginx",
        ensure => "running",
        enable => "true",
        require => Package['nginx']
    }

    file { '/etc/nginx/sites-enabled/default':
        ensure => file,
        content => file('software/nginx-default.conf'),
        mode => "0644",
        require => Package['nginx'],
        notify  => Service['Nginx']
    }

    file { '/etc/nginx/sites-enabled/jupyter.conf':
        ensure => present,
        content => epp('software/jupyter-nginx.conf', { 'key' => $key_file, 'cert' => $cert_file }),
        mode => "0644",
        require => Package['nginx'],
        notify  => Service['Nginx']
    }
    
    file { '/etc/nginx/sites-enabled/gitea.conf':
        ensure => present,
        content => epp('software/gitea.conf', { 'key' => $key_file, 'cert' => $cert_file }),
        mode => "0644",
        require => Package['nginx'],
        notify  => Service['Nginx']
    }

    file { '/etc/nginx/sites-enabled/gotify.conf':
        ensure => present,
        content => epp('software/gotify.conf', { 'key' => $key_file, 'cert' => $cert_file }),
        mode => "0644",
        require => Package['nginx'],
        notify  => Service['Nginx']
    }

    file { '/etc/nginx/sites-enabled/exporter.conf':
        ensure => present,
        content => epp('software/prometheus-node-exporter-nginx.conf', { 'key' => $key_file, 'cert' => $cert_file }),
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
    
    if find_file("/etc/php") {
          class { '::php':
            settings   => {
                'PHP/display_errors'         => 'On',
                'PHP/display_startup_errors' => 'On',
                'PHP/error_reporting'        => 'E_ALL',
                'PHP/memory_limit'           => '256M',
                'PHP/max_input_time'         => '300',
                'PHP/max_execution_time'     => '90',
                'PHP/post_max_size'          => '32M',
                'PHP/upload_max_filesize'    => '32M'
            },
            fpm => true,
            fpm_pools => {
                'www' => {
                    'listen' => '/var/run/php/php8.2-fpm.sock',
                    'listen_owner' => "www-data",
                    'listen_group' => "www-data",
                    'user' => "www-data",
                    'group' => "www-data",
                    'clear_env' => false
                }
            }
        }
    }

    file { '/usr/bin/backup-pg.sh':
        ensure => present,
        mode => "0755",
        content => file('software/backup-pg.sh')
    }
}
