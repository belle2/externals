#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
from setup_tools import env_vars, source_scripts, add_path, remove_path


def unsetup_externals(location):
    """function to unsetup an externals directory"""

    subdir = os.environ.get('BELLE2_EXTERNALS_SUBDIR',
                            os.environ['BELLE2_SUBDIR'])

    # externals
    remove_path('PATH', os.path.join(location, 'bin', subdir))
    remove_path('LD_LIBRARY_PATH', os.path.join(location, 'lib', subdir))

    # geant4
    if os.environ.has_key('G4SYSTEM'):
        remove_path('LD_LIBRARY_PATH', os.path.join(os.environ['G4LIB'],
                    os.environ['G4SYSTEM']))
        remove_path('LD_LIBRARY_PATH', os.environ['CLHEP_LIB_DIR'])
        remove_path('PATH', os.path.join(os.environ['G4WORKDIR'], 'bin',
                    os.environ['G4SYSTEM']))
    for var in os.environ.keys():
        if var.startswith('G4'):
            env_vars[var] = ''
    for var in ['CLHEP_BASE_DIR', 'CLHEP_INCLUDE_DIR', 'CLHEP_LIB',
                'CLHEP_LIB_DIR']:
        env_vars[var] = ''

    # root
    root_dir = os.path.join(location, 'root')
    if env_vars.has_key('ROOTSYS') and env_vars['ROOTSYS'] == root_dir:
        env_vars['ROOTSYS'] = ''
    remove_path('PATH', os.path.join(root_dir, 'bin'))
    remove_path('LD_LIBRARY_PATH', os.path.join(root_dir, 'lib'))
    remove_path('PYTHONPATH', os.path.join(root_dir, 'lib'))


def setup_externals(location):
    """function to setup an externals directory"""

    subdir = os.environ.get('BELLE2_EXTERNALS_SUBDIR',
                            os.environ['BELLE2_SUBDIR'])

    # add externals directory to path and library path
    add_path('PATH', os.path.join(location, 'bin', subdir))
    add_path('LD_LIBRARY_PATH', os.path.join(location, 'lib', subdir))

    # geant4
    source_scripts.append([os.path.join(location, 'geant4', 'env.sh'),
                          os.path.join(location, 'geant4', 'env.csh')])

    # root
    root_dir = os.path.join(location, 'root')
    if os.path.isdir(root_dir):
        env_vars['ROOTSYS'] = root_dir
    add_path('PATH', os.path.join(root_dir, 'bin'))
    add_path('LD_LIBRARY_PATH', os.path.join(root_dir, 'lib'))
    add_path('PYTHONPATH', os.path.join(root_dir, 'lib'))


def check_externals(location):
    """function to check the externals installation"""

    result = True
    if not os.path.isfile(os.path.join(location, 'geant4', 'env.sh')):
        result = False
        sys.stderr.write('Error: geant4 installation is missing.\n')
    if not os.path.isfile(os.path.join(location, 'root', 'bin', 'root.exe')):
        result = False
        sys.stderr.write('Error: root installation is missing.\n')
    return result


def config_externals(conf):
    """function to configure the build system for the externals"""

    from SCons.Script import Environment

    # boost
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'boost'))

    # CLHEP
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'CLHEP'))

    # geant4
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'geant4'))
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

    # root
    conf.env.Append(CPPPATH=os.path.join(conf.env['EXTINCDIR'], 'root'))

    conf.env['ROOT_LIBS'] = conf.env['ROOT_GLIBS'] = []
    if conf.CheckConfigTool('root-config'):
        root_env = Environment(ENV=os.environ)
        root_env.ParseConfig('root-config --libs')
        conf.env['ROOT_LIBS'] = root_env['LIBS']
        root_env.ParseConfig('root-config --glibs')
        conf.env['ROOT_GLIBS'] = root_env['LIBS']
    else:
        print 'root configuration tool missing'
        print '-> create it with the command "scons externals"'
        return False

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

    return True


