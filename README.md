[![Build Status](https://ci.sagrid.ac.za/buildStatus/icon?job=lua-deploy)](https://ci.sagrid.ac.za/job/lua-deploy/)

# lua-deploy

Build, test and deploy scripts for [Lua](https://www.lua.org/) for CODE-RADE

# Dependencies

  * [readline](https://ci.sagrid.ac.za/job/readline-deploy)

# Versions

We build the following versions :

  * 6.1.2

# Configuration

Configuraiton is done using `sed` to edit the config files in place. This is done specifially for `CFLAGS` and `LDFLAGS` :

```
sed -i 's@^SYSLDFLAGS=.*$@SYSLDFLAGS="-L${READLINE_DIR}/lib -Wl,-export-dynamic"@g' src/Makefile
sed -i 's@SYSCFLAGS=.*$@SYSCFLAGS="-I${READLINE_DIR}/include -L${READLINE_DIR}/lib"@g' src/Makefile
```

# Citing
