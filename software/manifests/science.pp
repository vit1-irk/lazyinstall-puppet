class software::science {
    $user = 'vitya'
    
	$pkgs_common = ['geogebra', 'gnuplot', 'kmplot', 'graphviz', 'npm', 'texmaker', 'plantuml']
    
	$pkgs_debbased = ['gnuplot-qt', 'saods9', 'gnudatalanguage', 'libopenblas-base', 'plplot-driver-qt', 'plplot-driver-wxwidgets', 'plplot-driver-xwin', 'python3-dev', 'x2goserver']
    
	$pkgs_arch = ['ds9']
    
    $pip_packages = ['jupyter', 'jupyterlab', 'aiohttp', 'lxml', 'matplotlib', 'ipympl', 'numpy', 'scipy', 'sympy', 'pandas', 'seaborn', 'pillow', 'astropy', 'sunpy', 'sunkit-instruments', 'hvpy', 'apprise', 'requests', 'bs4', 'drms', 'zeep', 'h5netcdf', 'ipywidgets', 'papermill', 'dot_kernel', 'jupyter_scheduler', 'jupyter_collaboration', 'jupyterlab-link-share', 'iplantuml', 'pip-review', 'ipyparallel']
    
    $pkgs_uninst = ['xmaxima', 'wxmaxima', 'sbcl']

	$pkgs_custom = $operatingsystem ? {
		debian => $pkgs_debbased,
		ubuntu => $pkgs_debbased,
		archlinux => $pkgs_arch,
		manjarolinux => $pkgs_arch
	}

    package { $pkgs_common: ensure => "installed" }
	package { $pkgs_custom: ensure => "installed" }
	package { $pkgs_uninst: ensure => "absent" }
    
    package { $pip_packages: ensure => 'installed', provider => 'pip3' }
    
    vcsrepo { "/opt/IDLAstro":
        ensure   => present,
        provider => "git",
        source   => "https://github.com/wlandsman/IDLAstro"
    }
    
    $all_path = '/usr/local/bin/:/usr/bin'

    file { '/opt/latex-compose.yml':
        ensure => present,
        content => file('software/latex-compose.yml'),
        mode => "0644"
    }

    file { '/usr/bin/latex-docker':
        ensure => present,
        content => file('software/tex-wrapper.sh'),
        mode => "0755"
    }
    #$rpkgs = $operatingsystem ? {
    #    debian => ['r-base', 'r-recommended'],
    #    ubuntu => ['r-base', 'r-recommended'],
    #    archlinux => ['r'],
    #    manjarolinux => ['r']
    #}
    #package { $rpkgs: ensure => "installed" }
    #file { '/etc/R-packages.txt':
    #    ensure => present,
    #    content => file('software/R-packages.txt'),
    #    mode => "0644"
    #}
    #exec { 'install R packages': path => $all_path,
    #    subscribe   => Package[$rpkgs],
    #    require => File['/etc/R-packages.txt'],
    #    timeout => 800,
    #    refreshonly => true,
    #    command  => 'cat /etc/R-packages.txt | R CMD BATCH /dev/stdin /dev/stdout' }
}
