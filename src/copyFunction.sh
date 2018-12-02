#!/usr/bin/env bash

copyFunction() {
    local filePath="$1"
    local fName="$2"
    local outFile="$3"
    local fNameReg="^(function[[:space:]]+$fName|$fName)[[:space:]]*\(.*\)[[:space:]]*\{"
    local endFunc="^\}$"
    local startCopy=false

    local filename=$(basename -- $filePath)
    local key="$fName@$filename"

    local wasVisited=$(inState "$key")

    if [[ "$wasVisited" = "sim" ]]; then
        return;
    fi

    addToState "$key"

    while IFS="" read -r line || [[ -n "$line" ]]; do

        if [[ "$line" =~ $fNameReg ]]; then
            startCopy=true
        fi

        if [[ $startCopy == true && "$line" =~ $endFunc ]]; then
            echo -en "$line\n\n" >> "$outFile"
            startCopy=false
            break
        fi

        if $startCopy; then
            echo $line >> "$outFile"
        fi
    done < $filePath

}

copyFunction $1 $2 $3
