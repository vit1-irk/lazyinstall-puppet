class software::science {
    # ds9 on Arch - ?, install AUR packages
    # R, jupyter module, arch package
    # LaTeX - important
    
	$pkgs_common = ['geogebra', 'gnuplot', 'kmplot', 'wxmaxima', 'xmaxima', 'graphviz', 'x2goserver']
    
	$pkgs_debbased = ['gnuplot-qt', 'gnuplot-x11', 'saods9', 'gnudatalanguage', 'r-base', 'r-recommended', 'libopenblas-base', 'plplot-driver-qt', 'plplot-driver-wxwidgets', 'plplot-driver-xwin']
	$pkgs_arch = ['r']
    $pip_packages = ['jupyter', 'jupyterlab', 'aiohttp', 'lxml', 'matplotlib', 'numpy', 'scipy', 'pandas', 'seaborn', 'pillow', 'astropy', 'sunpy', 'apprise', 'requests', 'bs4', 'drms', 'zeep']
    
    $pkgs_uninst = []

	$pkgs_custom = $operatingsystem ? {
		debian => $pkgs_debbased,
		ubuntu => $pkgs_debbased,
		archlinux => $pkgs_arch,
		manjarolinux => $pkgs_arch
	}

    package { $pkgs_common: ensure => "installed" }
	package { $pkgs_custom: ensure => "installed" }
	package { $pkgs_uninst: ensure => "absent" }
    
    package { $pip_packages: ensure => 'latest', provider => 'pip3' }
    package { 'ipywidgets': ensure => 'latest', provider => 'pip3' } -> exec { 'enable jupyter extension': command => '/usr/local/bin/jupyter nbextension enable --py widgetsnbextension' } -> exec { 'install jupyterlab extension': command => '/usr/local/bin/jupyter labextension install @jupyter-widgets/jupyterlab-manager' }
    
    package { 'dot_kernel': ensure => 'latest', provider => 'pip3' } -> exec { 'install dot kernel': command  => '/usr/local/bin/install-dot-kernel' }
}