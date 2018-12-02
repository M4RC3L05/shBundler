#!/usr/bin/env bash

state=()




inState() {
    local query=$1

    for item in ${state[@]}; do
        if [[ "$query" = "$item" ]]; then
            printf "sim"
            return;
        fi
    done

    printf "nao"
}

printState() {
    for item in ${state[@]}; do
        echo "$item"
    done
}

addToState() {
    state+=("$1")
}
