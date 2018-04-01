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

        echo " > Installing mongodb"

        if [[ $IS_DEBIAN_BASED && $DEBIAN_VERSION == "7" || $DEBIAN_VERSION == "8" ]]
        then
            apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5

            if [[ $DEBIAN_VERSION == "7" ]]
            then
                echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
            elif [[ $DEBIAN_VERSION == "8" ]]
            then
                echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
            else
                echo "    - don't know how to install MongoDB on $MACHINE"
                return 0
            fi

            apt-get update
            apt-get install -y mongodb-org

            echo "    - mongodb installed using apt"
        else
            case $DEFAULT_MANAGER in
                homebrew)
                    brew update
                    brew install mongodb
                    echo "    - mongodb installed using homebrew"
                    ;;
                *)
                    echo "    - don't know how to install MongoDB on $MACHINE"
                    ;;
            esac
        fi

        cd $CURRENT_PATH
    *)
        echo "unknown command $CMD"
        ;;
esac
