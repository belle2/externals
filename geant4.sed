s;\$geant4_envbindir/../lib;\$geant4_envbindir/../../../lib\(64\)\?/\${BELLE2_EXTERNALS_SUBDIR};g
s;\$geant4_envbindir/../share;\$geant4_envbindir/../../../share;g
s;libdir=.*;libdir=\${BELLE2_EXTERNALS_DIR}/lib/\${BELLE2_EXTERNALS_SUBDIR};g
s;includedirs=.*;includedirs=\${BELLE2_EXTERNALS_DIR}/include/Geant4;g
s;clhep_config_exe=.*;clhep_config_exe=\${BELLE2_EXTERNALS_DIR}/bin/\${BELLE2_EXTERNALS_SUBDIR}/clhep-config;g
s;set g4sls_sourced_dir="`dirname \${ARGS\[2\]}`";set g4sls_sourced_dir=\${BELLE2_EXTERNALS_DIR}/bin/\${BELLE2_EXTERNALS_SUBDIR};