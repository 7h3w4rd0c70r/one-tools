#!/bin/bash

CMD=$1

case $CMD in
    "i")
        git init
        ;;
    "a")
        git add .
        ;;
    "c")
        git commit -m $2
        ;;
    "p")
        CURRENT_BRANCH="$(git symbolic-ref --short -q HEAD)"
        git push origin $CURRENT_BRANCH
        ;;
    *)
        echo "Invalid command "$CMD""
        ;;
esac
