basf2 Externals Build Instructions
==================================

To compile the external software needed by basf2 just source `b2setup` from the tools,
go into the externals directory and call

    make

If you want to specify if you want to build the externals in optimal or debug mode you
can either call `b2code-option-externals` before running make or specify the option
directly. You can also compile both options at the same time

    make opt debug

You can specify the numbers of processes to be used for the build process using the
`BELLE2_MAKE_NPROCESSES` variable. If it's not specified it defaults to the number of
processors present in the system.

    make BELLE2_MAKE_NPROCESSES=20


Creating new Externals
----------------------

To update the externals used by basf2 requires a few steps:

1. Update this repository to contain the packages you want
2. Make sure all source archives are uploaded to `b2-master`
3. Compile on all platforms
4. Upload the compiled externals to `b2-master`
5. Tag the new version and wait for buildbot to install it on cvmfs

### Update the repository

Updating a package in the simplest case just requires to update the URL for downloading
in `Makefile.targets`, the version number in `README.md` and the sha256 checksum in
`sha236sum.txt`. The first two have to be done manually but updating the checksum can be
done mostly automatically by running

    tools/update_sha.sh package [archivebasename]

In most case just giving the package name is enough. If the archive name is different
than the package name one can specify the beginning of the archive name as second
argument. For example the package `tauola` is lower case but the archive starts with
`TAUOLA` so one would run `tools/update_sha.sh tauola TAUOLA`.

### Make sure all source archives are uploaded on `b2-master`

We need to keep a mirror of all the software used in the externals to make sure we can
compile it even if the upstream page has problems or disappears. So we need to make sure
all packages are uploaded.

There's a script to do that: `tools/check_sources.sh`. It will check that all sources
are present locally by just verifying all files in the `sha256sum.txt` are present and
correct. In a second step it will do the same on `b2-master` and upload all missing
files.

This script requires to be able to login to `b2-master` with the software account
(please contact Thomas Kuhr) and have a ssh config for `b2-master` which will use the
correct account and jump setup to login. Password prompt will be shown if necessary but
a multiplexing setup with a control master is recommended to not get asked multiple
times.

For python packages there's a separate step as these are downloaded differently via pip
so we need to also use pip to download the sources. `tools/upload_python_packages.sh`
will do this but will take a long time and show some errors along the way.

### Compile on all platforms

The externals need to be compiled on all platforms we want to support and we need to
make sure that they are compiled on a system with minimal additional software to not
accidentally pick up additional dependencies (many packages are very annoying as they
just compile additional features and create dependencies if they find a matching library
on the system)

So the best choice is use containers for the compilation. We have a setup for this which
can be found at https://stash.desy.de/projects/B2X/repos/externals_docker_build. It
contains scripts to create the necessary docker images and run compilation of a given
git hash in all containers.

### Upload the externals to `b2-master`

After compilation of all externals is complete they have to be uploaded to `b2-master`
**before** tagging the version. Otherwise buildbot will try to compile them and fail
horribly. There's a script for this in the externals_docker_build repository (creatively
called `upload.sh`) which will do this (same requirements for `b2-master` login as
above).

### Tag the new version

Once everything is uploaded once can just tag the new version, push the tag and buildbot
will automatically install it on cvmfs. Don't forget to also release any associated
issues on JIRA into a new externals version.
