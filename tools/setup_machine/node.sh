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

        echo " > Installing node"

        if ! which node > /dev/null 2>&1
        then
            case $DEFAULT_MANAGER in
                apt)
                    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
                    apt-get install -y nodejs
                    echo "    - node installed using apt"
                    ;;
                homebrew)
                    brew install node
                    echo "    - node installed using homebrew"
                    ;;
                *)
                    echo "    - Cannot install node with $DEFAULT_MANAGER"
                    ;;
            esac
        else
            echo "    - node already installed"
        fi

        cd $CURRENT_PATH
    *)
        echo "unknown command $CMD"
        ;;
esac
