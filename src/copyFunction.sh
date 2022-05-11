#!/usr/bin/env bash

copyFunction() {
    local filePath="$1"
    local fName="$2"
    local outFile="$3"
    local fNameReg="^(function[[:space:]]+$fName|$fName)[[:space:]]*\(.*\)[[:space:]]*\{"
    local endFunc="^\}$"
    local inLineFn="^(function[[:space:]]+$fName|$fName)[[:space:]]*\(.*\)[[:space:]]*\{.*\}$"
    local startCopy=false
    local key="$fName@$filePath"

    inState "$filePath"
    local wasVisitedPath=$?

    inState "$key"
    local wasVisited=$?

    if [[ $wasVisited = 0 || $wasVisitedPath = 0 ]]; then
        return;
    fi

    addToState "$key"

    while IFS="" read -r line || [[ -n "$line" ]]; do

        if [[ "$line" =~ $inLineFn ]]; then
            echo -en "$line\n" >> "$outFile"
            return
        fi

        if [[ "$line" =~ $fNameReg ]]; then
            startCopy=0
        fi

        if [[ $startCopy = 0 && "$line" =~ $endFunc ]]; then
            echo -en "$line\n" >> "$outFile"
            startCopy=255
            break
        fi

        if [[ $startCopy = 0 ]]; then
            echo -e "$line" >> "$outFile"
        fi
    done < $filePath

}
