#!/bin/bash

if [ $(id -u) != "0" ]
then
    echo "sudo required"
    echo ""
    sudo "$0" "$@"
    exit $?
fi

echo "Installing tools..."

# Set install path

CURRENT_PATH="$(pwd)"
TOOLS_PATH="$CURRENT_PATH/tools"
INSTALL_PATH="/usr/local/OneTools"
BIN_PATH="/usr/local/bin"

#printf "    Install to path $INSTALL_PATH (Y/n) > "
#read IS_INSTALL_PATH_OK
#IS_OK="$(echo "$IS_INSTALL_PATH_OK" | tr '[:upper:]' '[:lower:]')"

#if [[ $IS_OK == "n" || $IS_OK == "no" ]]
#then
#    printf "    $INSTALL_PATH > "
#    read INSTALL_PATH
#fi

#printf "    Install bin to $BIN_PATH (Y/n) > "
#read IS_BIN_PATH_OK
#IS_OK="$(echo "$IS_BIN_PATH_OK" | tr '[:upper:]' '[:lower:]')"

#if [[ $IS_OK == "n" || $IS_OK == "no" ]]
#then
#    printf "    $BIN_PATH > "
#    read BIN_PATH
#fi

# Create app directory

if [ -d $INSTALL_PATH ]
then
  rm -R $INSTALL_PATH
fi

mkdir $INSTALL_PATH

cd $TOOLS_PATH
for TOOL in *.sh
do
    if [ -f $TOOL ]
    then
        TOOL_NAME=${TOOL%.sh}
        TOOL_FILE="$TOOLS_PATH/$TOOL"
        DIST_FILE="$INSTALL_PATH/$TOOL"
        LINK_FILE="$BIN_PATH/$TOOL_NAME"

        echo "  Installing $TOOL_NAME to $DIST_FILE"

        if [ -f $DIST_FILE ]
        then
            rm -D $DIST_FILE
        fi

        cp $TOOL_FILE $DIST_FILE
        chmod 755 $DIST_FILE
        ln -sf $DIST_FILE $LINK_FILE
    fi
done

cd $CURRENT_PATH

echo "Instalation complete"
