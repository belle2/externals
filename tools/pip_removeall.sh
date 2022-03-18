pip3 freeze | grep -vE "pip|setuptools|@" | xargs pip3 uninstall -y
