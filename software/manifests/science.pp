class software::science {
    $rpkgs = $operatingsystem ? {
        debian => ['r-base', 'r-recommended'],
        ubuntu => ['r-base', 'r-recommended'],
        archlinux => ['r'],
        manjarolinux => ['r']
    }
    
	$pkgs_common = ['geogebra', 'gnuplot', 'kmplot', 'wxmaxima', 'graphviz', 'x2goserver', 'npm', 'texmaker',   'texlive-humanities', 'texlive-pictures', 'texlive-pstricks', 'texlive-publishers', 'texlive-science']
    
	$pkgs_debbased = ['xmaxima', 'gnuplot-qt', 'saods9', 'gnudatalanguage', 'libopenblas-base', 'plplot-driver-qt', 'plplot-driver-wxwidgets', 'plplot-driver-xwin', 'python3-dev', 'texlive-binaries', 'texlive-base', 'texlive-bibtex-extra', 'texlive-fonts-extra', 'texlive-latex-extra', 'texlive-formats-extra', 'texlive-lang-cyrillic', 'texlive-lang-greek']
    
	$pkgs_arch = ['ds9', 'texlive-bin', 'texlive-core', 'texlive-bibtexextra', 'texlive-fontsextra', 'texlive-latexextra', 'texlive-formatsextra', 'texlive-langcyrillic', 'texlive-langgreek']
    
    $pip_packages = ['jupyter', 'jupyterlab', 'aiohttp', 'lxml', 'matplotlib', 'numpy', 'scipy', 'sympy', 'pandas', 'seaborn', 'pillow', 'astropy', 'sunpy', 'apprise', 'requests', 'bs4', 'drms', 'zeep', 'h5netcdf', 'ipywidgets', 'ipyleaflet', 'voila', 'voila-gridstack', 'papermill', 'dot_kernel', 'git+https://github.com/gnudatalanguage/gdl_kernel', 'jupyterlab_latex']
    
    $pkgs_uninst = []

	$pkgs_custom = $operatingsystem ? {
		debian => $pkgs_debbased,
		ubuntu => $pkgs_debbased,
		archlinux => $pkgs_arch,
		manjarolinux => $pkgs_arch
	}

    package { $pkgs_common: ensure => "installed" }
    package { $rpkgs: ensure => "installed" }
	package { $pkgs_custom: ensure => "installed" }
	package { $pkgs_uninst: ensure => "absent" }
    
    package { $pip_packages: ensure => 'installed', provider => 'pip3' }
    
    vcsrepo { "/opt/IDLAstro":
        ensure   => present,
        provider => "git",
        source   => "https://github.com/wlandsman/IDLAstro"
    }
    
    $all_path = '/usr/local/bin/:/usr/bin'
    
    # maybe remove it
    exec { 'jupyter-ipywidgets': path => $all_path,
        command => 'jupyter nbextension enable --py widgetsnbextension',
        refreshonly => true,
        subscribe => Package['ipywidgets']}
    ~> exec { 'jupyterlab-ipywidgets': path => $all_path,
        refreshonly => true,
        command => 'jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build' }
    ~> exec { 'jupyterlab-latex': path => $all_path,
        refreshonly => true,
        command => 'jupyter labextension install @jupyterlab/latex --no-build' }
    ~> exec { 'voila enable serverextension': path => $all_path,
        refreshonly => true,
        command => 'jupyter serverextension enable voila --sys-prefix' }
    ~> exec { 'jupyterlab_latex enable serverextension': path => $all_path,
        refreshonly => true,
        command => 'jupyter serverextension enable jupyterlab_latex --sys-prefix' }
    ~> exec {'jupyter lab build without minimize': path => $all_path,
        refreshonly => true,
        command => 'jupyter lab build --minimize=False' }
    
    
    exec { 'install dot kernel': path => $all_path,
        subscribe   => Package['dot_kernel'],
        refreshonly => true,
        command  => 'install-dot-kernel' }

    file { '/etc/R-packages.txt':
        ensure => present,
        content => file('software/R-packages.txt'),
        mode => "0644"
    }

    exec { 'install R packages': path => $all_path,
        subscribe   => Package[$rpkgs],
        require => File['/etc/R-packages.txt'],
        timeout => 800,
        refreshonly => true,
        command  => 'cat /etc/R-packages.txt | R CMD BATCH /dev/stdin /dev/stdout' }
}
