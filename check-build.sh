#!/bin/bash -e
# Check build for Lua
. /etc/profile.d/modules.sh
module load ci
module add readline
cd ${WORKSPACE}/${NAME}-${VERSION}
make test
echo $?
LDFLAGS="-Wl,-export-dynamic" CFLAGS="-I${READLINE_DIR}/include -L${READLINE_DIR}/lib" make install # DESTDIR=$SOFT_DIR
mkdir -p ${REPO_DIR}
# it's kinda wierd to make a module for lua, when lua is going to be used to replace modules wit lmod, but hey.
mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION."
setenv       LUA_VERSION       $VERSION
setenv       LUA_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(LUA_DIR)/lib
prepend-path PATH              $::env(LUA_DIR)/bin
MODULE_FILE
) > modules/$VERSION

mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/$VERSION ${LIBRARIES_MODULES}/${NAME}
