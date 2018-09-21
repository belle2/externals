pip3 freeze | grep -v "pip|setuptools" | xargs pip3 uninstall -y
