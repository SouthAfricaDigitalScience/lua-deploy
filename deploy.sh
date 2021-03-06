#!/bin/bash -e
# Lua deploy script
# this should be run after check-build finishes
. /etc/profile.d/modules.sh
echo ${SOFT_DIR}
module add deploy
module add ncurses
module add readline
echo ${SOFT_DIR}
cd ${WORKSPACE}/${NAME}-${VERSION}
sed -i 's@^INSTALL_TOP.*$@INSTALL_TOP= ${SOFT_DIR}@g' Makefile
echo "All tests have passed, will now build into ${SOFT_DIR}"
echo "Setting SYSLDFLAGS"
sed -i 's@^SYSLDFLAGS=.*$@SYSLDFLAGS="-L${READLINE_DIR}/lib -L${NCURSES_DIR}/lib -lreadline -lncurses -Wl,-export-dynamic"@g' src/Makefile
echo "Setting SYSCFLAGS"
sed -i 's@SYSCFLAGS=.*$@SYSCFLAGS="-I${READLINE_DIR}/include -I${NCURSES_DIR}/include"@g' src/Makefile
make linux install
echo "Creating the modules file directory ${LIBRARIES}"
mkdir -p ${LIBRARIES}/${NAME}
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION : See https://github.com/SouthAfricaDigitalScience/LUA-deploy"
setenv LUA_VERSION                        $VERSION
setenv LUA_DIR                                   $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH    $::env(LUA_DIR)/lib
prepend-path PATH                            $::env(LUA_DIR)/bin
MODULE_FILE
) > ${LIBRARIES}/${NAME}/${VERSION}
module add $NAME/$VERSION
which lua
