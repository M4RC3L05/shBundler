#!/usr/bin/env bash

source ./src/state.sh
source ./src/copyFunction.sh
source ./src/copyToFile.sh
source ./src/bundler.sh
source ./src/utils/spinner.sh

shBundler() {

    printf "\033c\n"


    if [[ -z "$1" ]]; then
        printf "You must suply the in index.sh!\n\n shBundler <dir> <outdir> <outfile>\n"
        return
    fi


    if [[ -z "$2" ]]; then
        printf "You must suply the out dir!\n\n shBundler <dir> <outdir> <outfile>\n"
        return
    fi

    local indexsh=$(realpath $1)
    local outDir=$(realpath $2)
    local outFile=${3:-"bundle.sh"}

    if  [[ -d "$indexsh" ]]; then
        indexsh="$indexsh/index.sh"

        if [[ ! -f "$indexsh" ]]; then
            printf "Invalid index.sh!\n\n shBundler <dir> <outdir> <outfile>\n"
            return
        fi

    elif [[ "${indexsh##*.}" != "sh" ]]; then
        printf "Invalid index.sh!\n\n shBundler <dir> <outdir> <outfile>\n"
        return
    fi

    if  [[ ! -d $outDir ]]; then
        spinner "mkdir $outDir" "Creating out folder:"
    else
        spinner "rm -rf $outDir/$outFile" "Removing old bundle file folder if exists:"
    fi

    local outPath="${outDir}/${outFile}"

    spinner "bundler $indexsh $outPath" "Bundling:"

    printf "Done!!!\n\n"
}

shBundler $1 $2 $3


