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

        echo " > Installing certbot"

        if [[ $IS_DEBIAN_BASED && $DEBIAN_VERSION == "7" ]]
        then
            wget https://dl.eff.org/certbot-auto
            chmod a+x certbot-auto
            certbot-auto
            echo "    - certbot installed using "
        elif [[ $IS_DEBIAN_BASED && $DEBIAN_VERSION == "8" ]]
        then
            apt-get install certbot -t jessie-backports
            echo "    - certbot installed using apt"
        else
            case $DEFAULT_MANAGER in
                homebrew)
                    echo "not implemented"
                    ;;
                *)
                    echo "    - Don't know how to install Certbot on $MACHINE"
                    ;;
            esac
        fi

        cd $CURRENT_PATH
    *)
        echo "unknown command $CMD"
        ;;
esac
