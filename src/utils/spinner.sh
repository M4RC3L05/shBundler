
spinner() {
    
    local cmd=$1
    local txt=$2

    $cmd &

    local PID=$!
    local marks=( '/' '-' '\' '|' )
    local i=1

    while [[ -d /proc/$PID ]]; do
        printf "\r%s [%c]" "$txt" "${marks[$i]}"
        sleep 0.1
        ((i+=1))
        if [[ $i -gt 4 ]]; then
            i=1
        fi
    done
    printf "\r%s [✓]\n" "$txt"

}