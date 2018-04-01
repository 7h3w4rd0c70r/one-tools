#!/bin/bash

CMD=$1
DEFAULT_MANAGER=$2
MACHINE=$3
IS_DEBIAN_BASED=$4
DEBIAN_VERSION=$5

case $CMD in
    install)
        CURRENT_PATH="$(pwd)"
        cd ~

        echo " > Installing pm2"

        npm install pm2 -g

        echo "    - pm2 installed using npm"

        cd $CURRENT_PATH
    *)
        echo "unknown command $CMD"
        ;;
esac
