trim() {
    # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable#answer-3352015

    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}
