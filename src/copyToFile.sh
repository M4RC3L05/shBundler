#!/usr/bin/env bash

i=0

copyToFile() {
    local inFile=$1
    local outFile=$2

    local importAbs="^(source|\#[[:space:]]*import|\.)[[:space:]]+(\/.+)"
    local importRel="^(source|\#[[:space:]]*import|\.)[[:space:]]+(\.\/.+)"
    local importHome="^(source|\#[[:space:]]*import|\.)[[:space:]]+(\~\/.+)"
    local importFuncAbs="^(\#[[:space:]]*import)[[:space:]]+\{[[:space:]]*(.+)[[:space:]]*\}[[:space:]]+(\/.+)"
    local importFuncRel="^(\#[[:space:]]*import)[[:space:]]+\{[[:space:]]*(.+)[[:space:]]*\}[[:space:]]+(\.\/.+)"
    local importFuncHome="^(\#[[:space:]]*import)[[:space:]]+\{[[:space:]]*(.+)[[:space:]]*\}[[:space:]]+(\~\/.+)"
    local varReg="^([\$_a-zA-Z]+[\$_\w]*\=.+)$"
    local shebang="^\#\!\/(usr\/bin\/env[[:space:]]bash|bin\/bash)"

    inState "$inFile"
    local wasVisited=$?
    if [[ $wasVisited = 0 ]]; then
        return
    fi

    addToState "$inFile"

    if [[ i -eq 0 ]]; then
        echo -en "#!/usr/bin/env bash\n\n" >> $outFile
    fi

    ((i+=1))

    while IFS="" read -r line || [[ -n "$line" ]]; do

        if [[ ${line} =~ ${shebang} ]]; then
            continue

        elif [[ ${line} =~ ${importHome} ]]; then
            local importPath="${BASH_REMATCH[2]}"

            local file=$(basename -- $importPath)

            if [[ ${file##*.} != "sh" ]]; then
                continue
            fi

            local pathFormated=$(realpath ${importPath/"~"/$HOME})

            copyToFile $pathFormated $outFile
            continue

        elif [[ "$line" =~ $importRel ]]; then
            local importPath="${BASH_REMATCH[2]}"

            local file=$(basename -- $importPath)

            if [[ ${file##*.} != "sh" ]]; then
                continue
            fi

            local baseDir=$(cd $(dirname $inFile) && pwd)
            local pathFormated=$(realpath ${importPath/"."/$baseDir})

            copyToFile $pathFormated $outFile
            continue

        elif [[ "$line" =~ $importAbs ]]; then
            local importPath="${BASH_REMATCH[2]}"
            local file=$(basename -- $importPath)

            if [[ ${file##*.} != "sh" ]]; then
                continue
            fi

            copyToFile $importPath $outFile
            continue

        elif [[ "$line" =~ $importFuncAbs ]]; then

            local funcName="${BASH_REMATCH[2]}"
            local importPath="${BASH_REMATCH[3]}"
            local file=$(basename -- $importPath)

            if [[ ${file##*.} != "sh" ]]; then
                continue
            fi

            IFS=',' read -ra fNamesArr <<< "$funcName"
            for fn in "${fNamesArr[@]}"; do
                local finalFN=$(trim "$fn")
                copyFunction $importPath $finalFN $outFile
            done

            continue

        elif [[ "$line" =~ $importFuncHome ]]; then

            local funcName="${BASH_REMATCH[2]}"
            local importPath="${BASH_REMATCH[3]}"
            local file=$(basename -- $importPath)

            if [[ ${file##*.} != "sh" ]]; then
                continue
            fi

            local pathFormated=$(realpath ${importPath/"~"/$HOME})

            IFS=',' read -ra fNamesArr <<< "$funcName"
            for fn in "${fNamesArr[@]}"; do
                local finalFN=$(trim "$fn")
                copyFunction $pathFormated $finalFN $outFile
            done

            continue


        elif [[ "$line" =~ $importFuncRel ]]; then
            local funcName="${BASH_REMATCH[2]}"
            local importPath="${BASH_REMATCH[3]}"
            local file=$(basename -- $importPath)

            if [[ ${file##*.} != "sh" ]]; then
                continue
            fi

            local baseDir=$(cd $(dirname $inFile) && pwd)
            local pathFormated=$(realpath ${importPath/"."/$baseDir})



            IFS=',' read -ra fNamesArr <<< "$funcName"
            for fn in "${fNamesArr[@]}"; do
                local finalFN=$(trim "$fn")
                copyFunction $pathFormated $finalFN $outFile
            done

            continue

        fi

        echo "$line" >> $outFile

    done < $inFile

    echo -e "\n" >> $outFile
}
