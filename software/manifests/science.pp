class software::science {
    # ds9 on Arch - ?, install AUR packages
    # ipywidgets jupyterlab module
    # R, jupyter module, arch package
    # LaTeX - important
    
	$pkgs_common = ['geogebra', 'gnuplot', 'kmplot', 'wxmaxima', 'xmaxima', 'graphviz', 'x2goserver']
    
	$pkgs_debbased = ['gnuplot-qt', 'gnuplot-x11', 'saods9', 'gnudatalanguage', 'r-base', 'r-recommended', 'libopenblas-base', 'plplot-driver-qt', 'plplot-driver-wxwidgets', 'plplot-driver-xwin']
	$pkgs_arch = ['r']
    $pip_packages = ['jupyter-notebook', 'jupyterlab', 'ipywidgets', 'aiohttp', 'lxml', 'matplotlib', 'numpy', 'pandas', 'seaborn', 'pillow', 'astropy', 'sunpy', 'apprise', 'requests', ]
    
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
    
    pythonpip { $pip_packages: ensure => 'latest' }
}