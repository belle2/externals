This directory contains a few scripts that are useful for checking/updating the
externals and are not required for just installing/compiling and using them.

### Upgrading the python version
First of all, updating the python version requires great care of the environment in which it is performed. 
One can get easily biased by local settings, such as links in `$PATH` and `$PYTHONPATH`, or local installations of python (the python compilation is also not protected from local installations). 
Thus, we recommend developing the python upgrade in a Docker container which is provided in the root directory of the externals package.

The recommended way of upgrading the python version works as follows:
(Note: Building and running a docker container requires root rights on the machine)
1. **Build the docker container.**

    ```
    # docker build -t externals .
    ```
2. **Run and connect to the docker container.** 
From here on, the operation continues in the docker container.

    ```
    # docker run -it externals
    ```

3. **Apply your changes.** 
Either you directly write into the files that are present in `/home/belle2/externals/externals/` or you pull your changes into a separate directory. 
Doing the latter way, keep in mind to change the paths accordingly. 
General changes should occur in the `Makefile.targets` file where you specify the new python version in the python target, 
adjust all compilation flags that specify a python version, e.g. `Python_ADDITIONAL_VERSIONS`, 
and libraries that contain the python version, e.g. `libboost_python.so`. 
Additional changes can occur in the `requirements-core.in` file, whenever the PyTorch version is changed due to changes to the link to the CPU version and its hash.

4. **Compile the new python version.**

    ```
    $ source tools/b2setup
    $ cd externals/externals
    $ export BELLE2_EXTERNALS_IGNORE_CHECKSUM=1
    $ make python
    ```

5. **Create new requirements files.**

    ```
    $ export BELLE2_EXTERNALS_TOPDIR=/home/belle2/externals
    $ b2setup-externals externals
    $ pip3 install -r tools/requirements-externals.txt
    $ python3 tools/create_python_requirements.py --python Linux_x86_64/common/bin/python3 --upgrade
    ```
6. **Clean the build files and compile the externals.**

    ```
    $ rm -fr build include share Linux_x86_64
    $ find src/* -maxdepth 0 -type d ! \( -name python-packages -o -name sphinx-argparse \) -exec rm -fr {} +
    $ make all
    ```


If the externals compile successfully, the next step is to check if `basf2` compiles with the new externals version.

7. **Set up the basf2 environment.**
This step requires a few detours since an update of the python version requires running all tests in `basf2``.

    ```
    $ export BELLE2_SOFTWARE_REPOSITORY=git@gitlab.desy.de:belle2/software/basf2.git
    $ export BELLE2_VERSIONING_REPOSITORY=git@gitlab.desy.de:belle2/software/versioning.git
    $ ssh-keygen -t rsa
    ```
    The created key needs to be deployed on the DESY GitLab.
    For this, copy the output of the public key (e.g. `cat /root/.ssh/id_rsa` if you kept everything to default) and paste it into your ssh keys. 
    You can access your keys via GitLab: `User Settings/ SSH Keys`.

8. **Clone basf2 and adjust the externals version for basf2.** 
This can be done by changing the first line of the `.externals` in your local `basf2` checkout to the name of the externals top directory.

    ``` 
    $ b2code-create MyBasf2
    $ cd MyBasf2
    $ echo "externals" > .externals
    $ b2setup
    ```

9. **Get the basf2 example data.**

    ```
    $ b2install-data validation
    $ b2install-data examples
    $ export BELLE2_VALIDATION_DATA_DIR=/home/belle2/validation-data
    $ export BELLE2_EXAMPLES_DATA_DIR=/home/belle2/examples-data
    ```

10. **Compile basf2 and run tests.**

    ```
    $ scons
    $ b2test-units
    $ b2test-scripts
    ```
