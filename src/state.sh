#!/usr/bin/env bash

state=()

inState() {
    local query=$1

    for item in ${state[@]}; do
        if [[ "$query" == "$item" ]]; then
            return 0
        fi
    done

    return 255
}

printState() {
    for item in ${state[@]}; do
        echo "$item"
    done
}

addToState() {
    state+=("$1")
}
