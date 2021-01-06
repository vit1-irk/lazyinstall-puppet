class software::science {
    # R, jupyter module
    # JHelioviewer + java - ?
    # GDL on archlinux + GDL-kernel

	$pkgs_common = ['geogebra', 'gnuplot', 'kmplot', 'wxmaxima', 'graphviz', 'x2goserver', 'npm', 'texmaker',   'texlive-humanities', 'texlive-pictures', 'texlive-pstricks', 'texlive-publishers', 'texlive-science']
    
	$pkgs_debbased = ['xmaxima', 'gnuplot-qt', 'saods9', 'gnudatalanguage', 'r-base', 'r-recommended', 'libopenblas-base', 'plplot-driver-qt', 'plplot-driver-wxwidgets', 'plplot-driver-xwin', 'texlive-binaries', 'texlive-base', 'texlive-bibtex-extra', 'texlive-fonts-extra', 'texlive-latex-extra', 'texlive-formats-extra', 'texlive-lang-cyrillic', 'texlive-lang-greek']
    
	$pkgs_arch = ['r', 'ds9', 'texlive-bin', 'texlive-core', 'texlive-bibtexextra', 'texlive-fontsextra', 'texlive-latexextra', 'texlive-formatsextra', 'texlive-langcyrillic', 'texlive-langgreek']
    
    $pip_packages = ['jupyter', 'jupyterlab', 'aiohttp', 'lxml', 'graphviz', 'matplotlib', 'numpy', 'scipy', 'pandas', 'seaborn', 'pillow', 'astropy', 'sunpy', 'apprise', 'requests', 'bs4', 'drms', 'zeep', 'h5netcdf', 'ipywidgets', 'dot_kernel']
    
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
    
    package { $pip_packages: ensure => 'installed', provider => 'pip3' }
    
    vcsrepo { "/opt/IDLAstro":
        ensure   => present,
        provider => "git",
        source   => "https://github.com/wlandsman/IDLAstro"
    }
    
    $all_path = '/usr/local/bin/:/usr/bin'
        
    exec { 'jupyter-ipywidgets': path => $all_path,
        command => 'jupyter nbextension enable --py widgetsnbextension',
        refreshonly => true,
        subscribe => Package['ipywidgets']}
    ~> exec { 'jupyterlab-ipywidgets': path => $all_path,
        refreshonly => true,
        command => 'jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build'}
    ~> exec {'jupyter lab build without minimize': path => $all_path,
        refreshonly => true,
        command => 'jupyter lab build --minimize=False' }
    
    
    exec { 'install dot kernel': path => $all_path,
        subscribe   => Package['dot_kernel'],
        refreshonly => true,
        command  => 'install-dot-kernel' }
}
