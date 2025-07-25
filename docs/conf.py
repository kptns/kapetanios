import os
import sys
sys.path.insert(0, os.path.abspath(".."))

project = "Kapetanios"
author = "Francisco Moreno"
release = "0.1.0"

extensions = [
    "myst_parser",
]

source_suffix = {
    ".rst": "restructuredtext",
    ".md": "markdown",
}

templates_path = ["_templates"]
exclude_patterns = []

html_theme = "alabaster"
html_static_path = ["_static"]
