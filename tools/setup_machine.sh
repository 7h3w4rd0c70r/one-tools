#!/bin/bash

if [ $(id -u) != "0" ]
then
    echo "sudo required"
    echo ""
    sudo "$0" "$@"
    exit $?
fi

DEFAULT_MANAGER="apt"

MACHINE="$(uname -s)"
case UNAME in
    Linux*)
        MACHINE="linux"
        DEFAULT_MANAGER="apt"
        return 0
    Darwin*)
        MACHINE="osx"
        DEFAULT_MANAGER="homebrew"
        return 0
    *) return 0
esac

IS_DEBIAN_BASED=false
DEBIAN_VERSION=$(cat /dev/null)
if [ -f /etc/debian_version ]
then
   IS_DEBIAN_BASED=true
   DEBIAN_VERSION=$(sed 's/\..*//' /etc/debian_version)
fi

function installNginx() {
    echo "  Installing nginx"

    if ! which nginx > /dev/null 2>&1
    then
        case $DEFAULT_MANAGER in
            "apt")
                apt-get install nginx
                return 0
            "homebrew")
                brew install nginx
                return 0
            *)
                echo "    Cannot install nginx with $DEFAULT_MANAGER"
                return 0
        esac
    else
        echo "    Nginx already installed"
    fi
}

function installNode() {
    echo "  Installing node"

    if ! which node > /dev/null 2>&1
    then
        case $DEFAULT_MANAGER in
            "apt")
                curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
                apt-get install -y nodejs
                return 0
            "homebrew")
                brew install node
                return 0
            *)
                echo "    Cannot install node with $DEFAULT_MANAGER"
                return 0
        esac
    else
        echo "    Node already installed"
    fi
}

function installPm2() {
    echo "  Installing pm2"

    npm install pm2 -g
}

function installMongoDB() {
    echo "  Installing MongoDB"

    if [ IS_DEBIAN_BASED ]
    then
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5

        if [[ $DEBIAN_VERSION == "7" ]]
        then
            echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
        else if [[ $DEBIAN_VERSION == "8" ]]
        then
            echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
        else
            echo "    Don't know how to install for Debian $DEBIAN_VERSION"
            return 0
        fi

        apt-get update
        apt-get install -y mongodb-org

        return 0
    fi

    case $DEFAULT_MANAGER in
        "homebrew")
            brew update
            brew install mongodb
            return 0
        *)
            echo "    Don't know how to install MongoDB on $MACHINE"
            return 0
    esac
}

function installCertbot() {
    echo "  Installing MongoDB"

    if [ IS_DEBIAN_BASED ]
    then
        if [[ $DEBIAN_VERSION == "7" ]]
        then
            wget https://dl.eff.org/certbot-auto
            # TODO: fix
            chmod a+x certbot-auto
        else if [[ $DEBIAN_VERSION == "8" ]]
        then
            apt-get install certbot -t jessie-backports
        else
            echo "    Don't know how to install for Debian $DEBIAN_VERSION"
            return 0
        fi

        apt-get update
        apt-get install -y mongodb-org

        return 0
    fi

    case $DEFAULT_MANAGER in
        "homebrew")
            brew update
            brew install mongodb
            return 0
        *)
            echo "    Don't know how to install MongoDB on $MACHINE"
            return 0
    esac
}

cd ~

installNginx
installNode
installPm2
installMongoDB
installCertbot
