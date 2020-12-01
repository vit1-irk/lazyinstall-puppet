class software::server {
	$pkgs = ['letsencrypt', 'certbot', 'nginx', 'fail2ban', 'emacs-nox']
	$pkgs_uninst = ['apache2-bin', 'apache2-utils']
    
	package { $pkgs: ensure => "installed" }
    package { $pkgs_uninst: ensure => "absent" }
}