
pathsVisited=()


inArr() {
    local query=$1
    local arr=${@:2}

    for item in ${arr[@]}; do
        if [[ "$query" = "$item" ]]; then
            printf "sim"
            return;
        fi
    done

    printf "nao"
}

i=0

copyToFile() {
    local inFile=$1
    local outFile=$2

    local importAbs="^(source|\#[[:space:]]*import|\.)[[:space:]]+(\/.+)"
    local importRel="^(source|\#[[:space:]]*import|\.)[[:space:]]+(\.\/.+)"
    local importHome="^(source|\#[[:space:]]*import|\.)[[:space:]]+(\~\/.+)"

    local wasVisited=$(inArr $inFile "${pathsVisited[@]}")

    if [[ "$wasVisited" = "sim" ]]; then
        return;
    fi

    pathsVisited+=("$inFile")

    if [[ i -eq 0 ]]; then
        echo -en "#!/usr/bin/env bash\n\n" >> $outFile
    fi

    ((i+=1))

    while IFS="" read -r line || [[ -n "$line" ]]; do
        
        if [[ ${line} =~ ${importHome} ]]; then
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
            
        fi

        
        echo "$line" >> $outFile

    done < $inFile
    
    echo -e "\n" >> $outFile
}