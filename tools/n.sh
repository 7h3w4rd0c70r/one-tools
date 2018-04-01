#!/bin/bash

CMD=$1

case $CMD in
    "")
        node
        ;;
    "r")
        node $2
        ;;
    *)
        echo "Invalid command "$CMD""
        ;;
esac
