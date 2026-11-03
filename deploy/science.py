"""Научное окружение: DS9, LaTeX, Jupyter и python-стек. Включает base.

Запуск (от root):  pyinfra @local deploy/science.py
"""

from pyinfra import local
from pyinfra.operations import apt, pacman, pip, server
from lib import distro_flags

local.include("deploy/base.py")

F = distro_flags()

SCIENCE_PACKAGES = ["geogebra", "graphviz", "npm", "plantuml", "texstudio"]

PIP_PACKAGES = [
    "aiohttp",
    "apprise",
    "astropy",
    "bs4",
    "dot_kernel",
    "drms",
    "h5netcdf",
    "hvpy",
    "ipympl",
    "ipywidgets",
    "iplantuml",
    "jupyter_collaboration",
    "jupyter_scheduler",
    "jupyterlab",
    "jupyterlab-link-share",
    "lxml",
    "matplotlib",
    "numpy",
    "pandas",
    "pillow",
    "requests",
    "scipy",
    "seaborn",
    "sunpy",
    "sunkit-instruments",
    "sympy",
    "zeep",
]

if F["deb"]:
    apt.packages(name="Science packages (Debian-based)", packages=["saods9", "python3-dev"])
elif F["arch"]:
    pacman.packages(name="Science packages (Arch)", packages=["ds9"])

server.packages(name="Science packages", packages=SCIENCE_PACKAGES)

pip.packages(name="Python science stack", packages=PIP_PACKAGES, pip="pip3")
