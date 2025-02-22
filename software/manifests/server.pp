class software::server {
    $user = 'vitya'
    $pkgs = ['apache2-utils', 'letsencrypt', 'certbot', 'python3-certbot-nginx', 'nginx', 'fail2ban', 'tcpdump', 'prometheus-node-exporter']
    $pkgs_uninst = ['apache2-bin']
    
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
