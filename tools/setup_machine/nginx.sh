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

        echo " > Installing nginx"

        if ! which nginx > /dev/null 2>&1
        then
            case $DEFAULT_MANAGER in
                apt)
                    apt-get install nginx
                    echo "    - nginx installed using apt"
                    ;;
                homebrew)
                    brew install nginx
                    echo "    - nginx installed using homebrew"
                    ;;
                *)
                    echo "    - cannot install nginx with $DEFAULT_MANAGER"
                    ;;
            esac
        else
            echo "    - nginx already installed"
        fi

        cd $CURRENT_PATH
        ;;
    *)
        echo "unknown command $CMD"
esac
