#!/bin/bash

CMD=$1

case $CMD in
    "init")
        npm init -y
        PACKAGE_JSON_FILE="$(pwd)/package.json"
        sed -i -e 's/ISC/MIT/g' $PACKAGE_JSON_FILE
        sed -i -e 's/"author": ""/"author": "Patrik Šimunič <patriksimunic@hotmail.com>"/g' $PACKAGE_JSON_FILE
        if [[ -f "$(pwd)/package.json-e" ]]
        then
            rm -R "$(pwd)/package.json-e"
        fi
        ;;
    *)
        echo "Invalid command "$CMD""
        ;;
esac
