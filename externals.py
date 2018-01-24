#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import subprocess
from setup_tools import env_vars, source_scripts, add_path, remove_path, \
    lib_path_name


def get_python_incdir(bin_dir, lib_dir):
    """Determine the python include directory.
    :param str bin_dir: directory containing the python executable
    """
    script = os.path.join(bin_dir, "python3")
    env = dict(os.environ)
    env["LD_LIBRARY_PATH"] = lib_dir
    proc = subprocess.Popen([script, "-c", "import sysconfig; print(sysconfig.get_path('include'))"],
                            stdout=subprocess.PIPE, env=env)
    stdout = str(proc.communicate()[0].decode())
    if proc.returncode != 0:
        raise RuntimeError("Cannot determine python include directory" + script)
    return stdout.strip()


def unsetup_externals(location, common=False):
    """function to unsetup an externals directory"""

    if common:
        subdir = os.path.join(os.environ["BELLE2_ARCH"], "common")
    else:
        unsetup_externals(location, True)
        subdir = os.environ.get('BELLE2_EXTERNALS_SUBDIR',
                                os.environ['BELLE2_SUBDIR'])

    # externals
    bin_dir = os.path.join(location, subdir, 'bin')
    lib_dir = os.path.join(location, subdir, 'lib')
    remove_path('PATH', bin_dir)
    remove_path(lib_path_name, lib_dir)
    remove_path(lib_path_name, lib_dir + '64')

    # geant4
    remove_path("ROOT_INCLUDE_PATH", os.path.join(location, "include", "Geant4"))
    remove_path("ROOT_INCLUDE_PATH", os.path.join(location, "include", "CLHEP"))
    for var in os.environ.keys():
        if var.startswith('G4'):
            env_vars[var] = ''

    # root
    root_dir = os.path.join(location, subdir, "root")
    if 'ROOTSYS' in env_vars and env_vars['ROOTSYS'] == root_dir:
        env_vars['ROOTSYS'] = ''
    remove_path('PATH', os.path.join(root_dir, 'bin'))
    remove_path(lib_path_name, os.path.join(root_dir, 'lib'))
    remove_path('PYTHONPATH', os.path.join(root_dir, 'lib'))
    # remove root 6 include paths again
    remove_path('ROOT_INCLUDE_PATH', location)
    remove_path('ROOT_INCLUDE_PATH', os.path.join(location, 'include'))

    if common:
        # remove git
        env_vars['GIT_EXEC_PATH'] = ''
        env_vars['GIT_TEMPLATE_DIR'] = ''
        env_vars['GIT_GUI_LIB_DIR'] = ''
        env_vars['GITPERLLIB'] = ''
        # and also intel compiler specific variable
        env_vars['GXX_INCLUDE'] = ''
        # and the valgrind tool directory
        if os.path.exists(os.path.join(bin_dir, "valgrind")):
            env_vars['VALGRIND_LIB'] = ''
        # and remove python include path for all root classes which need python
        remove_path('ROOT_INCLUDE_PATH', get_python_incdir(bin_dir, lib_dir))

        # remove epics vars
        env_vars['EPICS_BASE'] = ''
        env_vars['EPICS_HOST_ARCH'] = ''

    # pythia
    env_vars['PYTHIA8DATA'] = ''

    # panther
    env_vars['PANTHER_TABLE_DIR'] = ''


def setup_externals(location, common=False):
    """function to setup an externals directory"""

    if common:
        subdir = os.path.join(os.environ["BELLE2_ARCH"], "common")
    else:
        setup_externals(location, True)
        subdir = os.environ.get('BELLE2_EXTERNALS_SUBDIR',
                                os.environ['BELLE2_SUBDIR'])

    bin_dir = os.path.join(location, subdir, 'bin')
    lib_dir = os.path.join(location, subdir, 'lib')
    add_path('PATH', bin_dir)
    add_path(lib_path_name, lib_dir)
    add_path(lib_path_name, lib_dir + '64')

    # add include path so ROOT is able to find dictionary headers
    add_path('ROOT_INCLUDE_PATH', location)
    add_path('ROOT_INCLUDE_PATH', os.path.join(location, 'include'))
    add_path('ROOT_INCLUDE_PATH', os.path.join(location, 'include', 'libxml2'))

    # geant4
    geant4_dir = os.path.join(location, subdir, 'bin')
    if os.path.isfile(os.path.join(geant4_dir, 'geant4.sh')):
        source_scripts.append([os.path.join(geant4_dir, 'geant4.sh'),
                               os.path.join(geant4_dir, 'geant4.csh')])
        # make sure Geant4 includes are also found by ROOT in case someone
        # includes those in a dataobject class
        add_path("ROOT_INCLUDE_PATH", os.path.join(location, "include", "Geant4"))
        add_path("ROOT_INCLUDE_PATH", os.path.join(location, "include", "CLHEP"))

    # root
    root_dir = os.path.join(location, subdir, "root", "bin")
    if os.path.isfile(os.path.join(root_dir, "thisroot.sh")):
        source_scripts.append([os.path.join(root_dir, "thisroot.sh"),
                               os.path.join(root_dir, "thisroot.csh")])

    if common:
        # we have to setup git to be relocatable. Inspired by bin-wrappers/git in the git build
        # directory
        env_vars['GIT_EXEC_PATH'] = os.path.join(location, subdir, 'libexec', 'git-core')
        env_vars['GIT_TEMPLATE_DIR'] = os.path.join(location, 'share', 'git-core', 'templates')
        env_vars['GIT_GUI_LIB_DIR'] = os.path.join(location, 'share', 'git-gui', 'lib')
        # set up perl path for git-svn. Sadly this directory is somewhere
        # depending on the distribution (centos 5:
        # $BELLE2_ARCH/common/lib/perl5/site_perl/5.8.8/, centos 6,7:
        # share/perl5, ubuntu: share/perl/$VERSION/ ...
        # So let's do the lazy approach and find it by looking at all
        # possible directories and looking for Git.pm in there

        def find_perl():
            """small helper to find the correct perl directory where the Git.pm is installed"""
            for base in ["share/perl", "share/perl5", os.path.join(subdir, "lib/perl"), os.path.join(subdir, "lib/perl5")]:
                abs_base = os.path.join(location, base)
                for dirname, dirs, filenames in os.walk(abs_base):
                    if "Git.pm" in filenames:
                        return os.path.join(abs_base, dirname)
            # nothing found ... let's not set it, only git-cvsexportcommit,
            # git-svn, git-send-email, git-difftool, git-cvsimport and git-add
            # --interactive seem to use it so this does not seem to be fatal.
            sys.stderr.write("Warning: can not find Git perl bindings, some git commands might not work\n")
            return ""

        env_vars['GITPERLLIB'] = find_perl()

        # set path to the GCC c++ includes for intel compiler. Seems to be
        # needed in rare cases to avoid "icpc: error #10001: could not find
        # directory in which the set of libstdc++ include files resides"
        env_vars['GXX_INCLUDE'] = os.path.join(location, 'include', 'c++')

        # another one: Valgrind has an absolute path to the tools compiled in
        # (at least as far as I could find) so we have to set the environment
        # correctly
        if os.path.exists(os.path.join(bin_dir, "valgrind")):
            env_vars['VALGRIND_LIB'] = os.path.join(location, subdir, 'lib', 'valgrind')

        # and also add the python include path for all root classes which need python
        add_path('ROOT_INCLUDE_PATH', get_python_incdir(bin_dir, lib_dir))

        # set epics vars
        env_vars['EPICS_BASE'] = os.path.join(location, subdir, 'epics')
        env_vars['EPICS_HOST_ARCH'] = 'linux-x86_64'

        # ok, the rest is stuff we don't need fallbacks so we can return
        return

    # pythia
    env_vars['PYTHIA8DATA'] = os.path.join(location, 'share', 'Pythia8', 'xmldoc')

    # panther
    env_vars['PANTHER_TABLE_DIR'] = os.path.join(location, 'share', 'belle_legacy', 'panther')


def check_externals(location):
    """function to check the externals installation"""

    subdir = os.environ.get('BELLE2_EXTERNALS_SUBDIR',
                            os.environ['BELLE2_SUBDIR'])

    result = True
    if not os.path.isfile(os.path.join(location, subdir, 'bin', 'geant4.sh')):
        result = False
        # sys.stderr.write('Error: geant4 installation is missing.\n')
    root_dir = os.path.join(location, subdir, 'root')
    if not os.path.isfile(os.path.join(root_dir, 'bin', 'root.exe')):
        result = False
        # sys.stderr.write('Error: root installation is missing.\n')
    return result


def config_externals(conf):
    """function to configure the build system for the externals"""

    from SCons.Script import Environment

    subdir = os.environ.get('BELLE2_EXTERNALS_SUBDIR',
                            os.environ['BELLE2_SUBDIR'])

    # fix externals directories
    conf.env.Replace(
        EXTINCDIR=os.path.join('$EXTDIR', 'include'),
        EXTLIBDIR=os.path.join('$EXTDIR', subdir, 'lib'),
        EXTBINDIR=os.path.join('$EXTDIR', subdir, 'bin'),
    )

    def add_incdir(*components):
        """small helper to add a directory to the system include path"""
        conf.env.Append(CCFLAGS="-isystem%s" % os.path.join(*components))

    # configure python
    python_env = Environment(ENV=os.environ)
    python_env.ParseConfig("python3-config --includes --ldflags")
    conf.env["PYTHON_LIBS"] = python_env["LIBS"]
    conf.env.Append(LIBPATH=python_env["LIBPATH"])
    for incdir in python_env["CPPPATH"]:
        add_incdir(incdir)

    # CLHEP
    add_incdir(conf.env['EXTINCDIR'], 'CLHEP')

    # configure geant4
    add_incdir(conf.env['EXTINCDIR'], 'Geant4')
    conf.env['GEANT4_LIBS'] = [
        'G4digits_hits',
        'G4error_propagation',
        'G4event',
        'G4FR',
        'G4geometry',
        'G4global',
        'G4graphics_reps',
        'G4intercoms',
        'G4interfaces',
        'G4materials',
        'G4modeling',
        'G4parmodels',
        'G4particles',
        'G4physicslists',
        'G4processes',
        'G4RayTracer',
        'G4readout',
        'G4run',
        'G4track',
        'G4tracking',
        'G4Tree',
        'G4visHepRep',
        'G4vis_management',
        'G4visXXX',
        'G4VRML',
    ]

    # PostgreSQL
    conf.env['HAS_PGSQL'] = False
    conf.env['PGSQL_LIBS'] = []
    if conf.CheckLibWithHeader('pqxx', 'pgsql/pg_config.h', 'C++'):
        conf.env['HAS_PGSQL'] = True
        conf.env.Append(CPPDEFINES='-DHAS_PGSQL')
        add_incdir(subprocess.Popen(['pg_config', '--includedir'],
                                    stdout=subprocess.PIPE).communicate()[0].strip())
        conf.env['PGSQL_LIBS'] = ['pqxx', 'pq']

    # root
    add_incdir(conf.env['EXTINCDIR'], 'root')

    conf.env['ROOT_LIBS'] = conf.env['ROOT_GLIBS'] = []
    if conf.CheckConfigTool('root-config'):
        root_env = Environment(ENV=os.environ)
        root_env.ParseConfig('root-config --libs')
        conf.env['ROOT_LIBS'] = root_env['LIBS']
        root_env.ParseConfig('root-config --glibs')
        conf.env['ROOT_GLIBS'] = root_env['LIBS']

    # Rave
    conf.env.Append(CPPDEFINES={'RaveDllExport': ''})

    # belle_legacy
    add_incdir(conf.env['EXTINCDIR'], 'belle_legacy')

    return True
