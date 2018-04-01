#!/bin/bash

if [[ $(id -u) != "0" ]]
then
    echo "sudo required"
    echo ""
    sudo "$0" "$@"
    exit $?
fi

CURRENT_PATH="$(pwd)"
SCOPE_DIR="$(dirname "$(readlink -f "$0")")"

cd $SCOPE_DIR

echo " > Inspecting environment"

DEFAULT_MANAGER="apt"

MACHINE="$(uname)"
case $MACHINE in
    Linux)
        MACHINE="linux"
        DEFAULT_MANAGER="apt"
        ;;
    Darwin)
        MACHINE="osx"
        DEFAULT_MANAGER="homebrew"
        ;;
    *) ;;
esac

IS_DEBIAN_BASED=false
DEBIAN_VERSION=$(cat /dev/null)
if [ -f /etc/debian_version ]
then
   IS_DEBIAN_BASED=true
   DEBIAN_VERSION=$(sed 's/\..*//' /etc/debian_version)
fi

USED_SERVER="nginx"
INSTALL_SERVER=false
INSTALL_GIT=false
INSTALL_NODEJS=false
INSTALL_PM2=false
INSTALL_MONGO_DB=false
INSTALL_CERTBOT=false

for ARG in $@
do
    case $ARG in
        --apt)
            DEFAULT_MANAGER="apt"
            ;;
        --homebrew | --brew)
            DEFAULT_MANAGER="homebrew"
            ;;
        --debian-based)
            IS_DEBIAN_BASED=true
            ;;
        --not-debian-based)
            IS_DEBIAN_BASED=false
            ;;
        --linux)
            MACHINE="linux"
            ;;
        --osx)
            MACHINE="osx"
            ;;
        apache)
            USED_SERVER="apache"
            INSTALL_SERVER=true
            ;;
        nginx)
            USED_SERVER="nginx"
            INSTALL_SERVER=true
            ;;
        git)
            INSTALL_GIT=true
            ;;
        node | nodejs)
            INSTALL_NODEJS=true
            ;;
        pm2)
            INSTALL_PM2=true
            ;;
        mongodb)
            INSTALL_MONGO_DB=true
            ;;
        certbot)
            INSTALL_CERTBOT=true
            ;;
    esac
done

echo "    - DEFAULT_MANAGER = $DEFAULT_MANAGER"
echo "    - MACHINE = $MACHINE"
echo "    - IS_DEBIAN_BASED = $IS_DEBIAN_BASED"
echo "    - DEBIAN_VERSION = $DEBIAN_VERSION"

echo " > Using components:"

if [[ $INSTALL_PM2 == true && $INSTALL_NODEJS == false ]]
then
    echo "    - cannot install pm2 without node.js!"
    INSTALL_PM2=false
fi

echo "    - server: $USED_SERVER"
echo "    - install git: $INSTALL_GIT"
echo "    - install nodejs: $INSTALL_NODEJS"
echo "    - install mongodb: $INSTALL_MONGO_DB"
echo "    - install pm2: $INSTALL_PM2"
echo "    - install certbot: $INSTALL_CERTBOT"

if [[ $INSTALL_SERVER == true ]]
then
    if [[ $USED_SERVER == "nginx" ]]
    then
        cd $SCOPE_DIR
        bash ./nginx.sh install $DEFAULT_MANAGER $MACHINE $IS_DEBIAN_BASED $DEBIAN_VERSION
    elif [[ $USED_SERVER == "apache" ]]
    then
        cd $SCOPE_DIR
        bash ./apache.sh install $DEFAULT_MANAGER $MACHINE $IS_DEBIAN_BASED $DEBIAN_VERSION
    else
        echo " > Unknown server $USED_SERVER"
    fi
fi

if [[ $INSTALL_GIT == true ]]
then
    cd $SCOPE_DIR
    bash ./git.sh install $DEFAULT_MANAGER $MACHINE $IS_DEBIAN_BASED $DEBIAN_VERSION    
fi

if [[ $INSTALL_NODEJS == true ]]
then
    cd $SCOPE_DIR
    bash ./node.sh install $DEFAULT_MANAGER $MACHINE $IS_DEBIAN_BASED $DEBIAN_VERSION    
fi

if [[ $INSTALL_MONGO_DB == true ]]
then
    cd $SCOPE_DIR
    bash ./mongodb.sh install $DEFAULT_MANAGER $MACHINE $IS_DEBIAN_BASED $DEBIAN_VERSION    
fi

if [[ $INSTALL_PM2 == true ]]
then
    cd $SCOPE_DIR
    bash ./pm2.sh install $DEFAULT_MANAGER $MACHINE $IS_DEBIAN_BASED $DEBIAN_VERSION    
fi

if [[ $INSTALL_CERTBOT == true ]]
then
    cd $SCOPE_DIR
    bash ./certbot.sh install $DEFAULT_MANAGER $MACHINE $IS_DEBIAN_BASED $DEBIAN_VERSION
fi

cd $CURRENT_PATH
