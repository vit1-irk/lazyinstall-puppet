class software::science {
    $user = 'vitya'
    # ds9 on Arch - ?, install AUR packages
    # R, jupyter module, arch package
    # LaTeX - important
    # helioviewer-client + java - ?

	$pkgs_common = ['geogebra', 'gnuplot', 'kmplot', 'wxmaxima', 'xmaxima', 'graphviz', 'x2goserver', 'npm', 'texmaker',   'texlive-humanities', 'texlive-pictures', 'texlive-pstricks', 'texlive-publishers', 'texlive-science']
    
	$pkgs_debbased = ['gnuplot-qt', 'saods9', 'gnudatalanguage', 'r-base', 'r-recommended', 'libopenblas-base', 'plplot-driver-qt', 'plplot-driver-wxwidgets', 'plplot-driver-xwin', 'texlive-binaries', 'texlive-base', 'texlive-bibtex-extra', 'texlive-fonts-extra', 'texlive-latex-extra', 'texlive-formats-extra', 'texlive-lang-cyrillic', 'texlive-lang-greek']
    
	$pkgs_arch = ['r', 'texlive-bin', 'texlive-core', 'texlive-bibtexextra', 'texlive-fontsextra', 'texlive-latexextra', 'texlive-formatsextra', 'texlive-langcyrillic', 'texlive-langgreek']
    
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
    package { 'ipywidgets': ensure => 'latest', provider => 'pip3' } -> exec { 'enable jupyter extension': command => '/usr/local/bin/jupyter nbextension enable --py widgetsnbextension' } -> exec { 'install jupyterlab extension': command => '/usr/local/bin/jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build' } -> exec {'jupyter lab build without minimize', command => '/usr/local/bin/jupyter lab build --minimize=False'}
    
    package { 'dot_kernel': ensure => 'latest', provider => 'pip3' } -> exec { 'install dot kernel': command  => '/usr/local/bin/install-dot-kernel' } -> exec { 'install for user': command  => '/usr/local/bin/install-dot-kernel', user => $user }
}