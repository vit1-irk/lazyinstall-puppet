class software::server {
	$pkgs = ['letsencrypt', 'certbot', 'python3-certbot-nginx', 'nginx', 'fail2ban', 'emacs-nox', 'tcpdump']
	$pkgs_uninst = ['apache2-bin', 'apache2-utils']
    
	package { $pkgs: ensure => "installed" }
    package { $pkgs_uninst: ensure => "absent" }
}