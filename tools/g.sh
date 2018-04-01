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
    "remote")
        REMOTE_NAME="origin"
        if git config "remote.$REMOTE_NAME.url" > /dev/null; then
            git remote set-url $REMOTE_NAME $2
        else
            git remote add $REMOTE_NAME $2
        fi
        echo "remote $REMOTE_NAME set to $2"
        ;;
    *)
        echo "Invalid command "$CMD""
        ;;
esac
