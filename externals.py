#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
from setup_tools import env_vars, source_scripts, add_path, remove_path, \
    lib_path_name


def unsetup_externals(location):
    """function to unsetup an externals directory"""

    subdir = os.environ.get('BELLE2_EXTERNALS_SUBDIR',
                            os.environ['BELLE2_SUBDIR'])

    # externals
    remove_path('PATH', os.path.join(location, 'bin', subdir))
    remove_path(lib_path_name, os.path.join(location, 'lib', subdir))

    # geant4
    for var in os.environ.keys():
        if var.startswith('G4'):
            env_vars[var] = ''

    # root
    root_dir = os.path.join(location, 'build', 'root', subdir)
    if 'ROOTSYS' in env_vars and env_vars['ROOTSYS'] == root_dir:
        env_vars['ROOTSYS'] = ''
    remove_path('PATH', os.path.join(root_dir, 'bin'))
    remove_path(lib_path_name, os.path.join(root_dir, 'lib'))
    remove_path('PYTHONPATH', os.path.join(root_dir, 'lib'))

    # pythia
    env_vars['PYTHIA8DATA'] = ''


def setup_externals(location):
    """function to setup an externals directory"""

    subdir = os.environ.get('BELLE2_EXTERNALS_SUBDIR',
                            os.environ['BELLE2_SUBDIR'])

    # add externals directory to path and library path
    add_path('PATH', os.path.join(location, 'bin', subdir))
    add_path(lib_path_name, os.path.join(location, 'lib', subdir))

    # geant4
    source_scripts.append([os.path.join(location, 'bin', subdir, 'geant4.sh'),
                          os.path.join(location, 'bin', subdir, 'geant4.csh')])

    # root
    root_dir = os.path.join(location, 'build', 'root', subdir)
    if os.path.isdir(root_dir):
        env_vars['ROOTSYS'] = root_dir
    add_path('PATH', os.path.join(root_dir, 'bin'))
    add_path(lib_path_name, os.path.join(root_dir, 'lib'))
    add_path('PYTHONPATH', os.path.join(root_dir, 'lib'))

    # pythia
    env_vars['PYTHIA8DATA'] = os.path.join(location, 'share', 'pythia')


def check_externals(location):
    """function to check the externals installation"""

    subdir = os.environ.get('BELLE2_EXTERNALS_SUBDIR',
                            os.environ['BELLE2_SUBDIR'])

    result = True
    if not os.path.isfile(os.path.join(location, 'bin', subdir, 'geant4.sh')):
        result = False
        sys.stderr.write('Error: geant4 installation is missing.\n')
    root_dir = os.path.join(location, 'build', 'root', subdir)
    if not os.path.isfile(os.path.join(root_dir, 'bin', 'root.exe')):
        result = False
        sys.stderr.write('Error: root installation is missing.\n')
    return result


def config_externals(conf):
    """function to configure the build system for the externals"""

    from SCons.Script import Environment

    # CLHEP
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'CLHEP'))

    # geant4
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'Geant4'))
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

    # MySQL
    conf.env['HAS_MYSQL'] = False
    conf.env['MYSQL_LIBS'] = []
    if conf.CheckHeader('mysql/mysql.h'):
        conf.env['HAS_MYSQL'] = True
        conf.env.Append(CPPDEFINES='-DHAS_MYSQL')
        conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'mysql'))
        conf.env['MYSQL_LIBS'] = ['mysqlcppconn', 'mysqlclient']

    # PostgreSQL
    conf.env['HAS_PGSQL'] = False
    conf.env['PGSQL_LIBS'] = []
    if conf.CheckLibWithHeader('pqxx', 'pgsql/pg_config.h', 'C++'):
        conf.env['HAS_PGSQL'] = True
        conf.env.Append(CPPDEFINES='-DHAS_PGSQL')
        conf.env.Append(CPPPATH='pg_config --includedir')
        conf.env['PGSQL_LIBS'] = ['pqxx', 'pq']

    # root
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'root'))

    conf.env['ROOT_LIBS'] = conf.env['ROOT_GLIBS'] = []
    if conf.CheckConfigTool('root-config'):
        root_env = Environment(ENV=os.environ)
        root_env.ParseConfig('root-config --libs')
        conf.env['ROOT_LIBS'] = root_env['LIBS']
        root_env.ParseConfig('root-config --glibs')
        conf.env['ROOT_GLIBS'] = root_env['LIBS']

    # vgm
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'vgm'))

    # geant4_vmc
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'],
                    'geant4_vmc/g4root'))

    # genfit
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'genfit'))

    # HepMC
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'hepMC'))

    # Pythia
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'pythia'))

    # Photos
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'PHOTOS'))

    # Tauola
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'TAUOLA'))

    # EvtGen
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'evtgen'))

    # Rave
    conf.env.Append(CPPDEFINES={'RaveDllExport': ''})

    # FLC
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'FLC'))

    # eigen
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'Eigen'))

    return True


