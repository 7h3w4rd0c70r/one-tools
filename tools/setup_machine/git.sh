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

        echo " > Installing git"

        if [[ $MACHINE == "osx" ]]
        then
            git --version
            echo "    - git installed using xcode"
        else
            case $DEFAULT_MANAGER in
                apt)
                    apt install git-all
                    echo "    - git installed using apt"
                    ;;
                *)
                    echo "    - don't know how to install git on $MACHINE"
                    ;;
            esac
        fi

        cd $CURRENT_PATH
        ;;
    *)
        echo "unknown command $CMD"
        ;;
esac
