#!/bin/bash

CMD=$1

case $CMD in
    "r")
        certbot renew
        ;;
    *)
        echo "Invalid command "$CMD""
        ;;
esac
