cmake_minimum_required(VERSION 2.6)
cmake_policy(SET CMP0011 NEW)
 
IF(NOT DEFINED ENV{ROOTSYS})
   MESSAGE(FATAL_ERROR "You did not set the environment variable ROOTSYS. Please check your ROOT configuration.") 
ENDIF(NOT DEFINED ENV{ROOTSYS})

SET(CMAKE_CXX_FLAGS "-g -O3")

SET(GENFIT $ENV{GENFIT})

SET(GENFITLIBDIR ${GENFIT}/lib)
SET(GENFITLIBINSTALLDIR ${GENFITLIBDIR})
SET(LIBRARY_OUTPUT_PATH ${GENFITLIBDIR})

add_subdirectory(core)
add_subdirectory(RKTrackRep)
add_subdirectory(GFRave)
