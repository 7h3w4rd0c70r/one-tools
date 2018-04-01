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
INSTALL_PATH="/usr/local/UnixTools"
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

        echo " > Installing $TOOL_NAME to $DIST_FILE"

        if [ -f $DIST_FILE ]
        then
            rm -D $DIST_FILE
        fi

        cp $TOOL_FILE $DIST_FILE
        chmod 755 $DIST_FILE
        ln -sf $DIST_FILE $LINK_FILE

        echo "    - done"
    fi
done

for TOOL_DIR in *
do
    if [ -d $TOOL_DIR ]
    then
        if [ -f "$TOOL_DIR/$TOOL_DIR.sh" ]
        then
            TOOL_NAME=$TOOL_DIR
            DIST_DIR="$INSTALL_PATH/$TOOL_NAME"
            EXE_FILE="$INSTALL_PATH/$TOOL_NAME/$TOOL_NAME.sh"
            LINK_FILE="$BIN_PATH/$TOOL_NAME"

            echo " > Installing $TOOL_NAME to $DIST_DIR"

            if [ -d $DIST_DIR ]
            then
                rm -D $DIST_DIR
            fi

            mkdir $DIST_DIR

            cd $TOOL_DIR
            for FILE in *.sh
            do
                cp "$TOOLS_PATH/$TOOL_DIR/$FILE" "$DIST_DIR/$FILE"
                chmod 755 "$DIST_DIR/$FILE"
            done
            cd $TOOLS_PATH

            ln -sf $EXE_FILE $LINK_FILE

            echo "    - done"
        fi
    fi
done

cd $CURRENT_PATH

echo "Instalation complete"
