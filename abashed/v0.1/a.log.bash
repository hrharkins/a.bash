
echo "Loading logging..."

##############################################################################
##############################################################################

ABASHED_v0_1:fatal()
{
    echo fatal
}

##############################################################################
##############################################################################

ABASHED_v0_1:debug()
{
    [ "$ABASHED_LOG_LEVEL" -gt "${ABASHED[log-level:DEBUG]}" ] ||
    ABASHED_v0_1:log "$@"
}

ABASHED_v0_1:verbose()
{
    [ "$ABASHED_LOG_LEVEL" -gt "${ABASHED[log-level:VERBOSE]}" ] ||
    ABASHED_v0_1:log "$@"
}

ABASHED_v0_1:info()
{
    [ "$ABASHED_LOG_LEVEL" -gt "${ABASHED[log-level:INFO]}" ] ||
    ABASHED_v0_1:log "$@"
}

ABASHED_v0_1:warning()
{
    [ "$ABASHED_LOG_LEVEL" -gt "${ABASHED[log-level:WARNING]}" ] ||
    ABASHED_v0_1:log "$@"
}

ABASHED_v0_1:error()
{
    [ "$ABASHED_LOG_LEVEL" -gt "${ABASHED[log-level:ERROR]}" ] ||
    ABASHED_v0_1:log "$@"
}

##############################################################################
##############################################################################

ABASHED_v0_1:log()
{
    local msg="$1"; shift
    local prefix="${ABASHED_LOG_PREFIX:-}"

    msg="$( printf "$msg" "$@" )"
    set - $ABASHED_LOG_CONTEXT

    if [ "$msg" = - ]
    then
        if [ $# -gt 0 ]
        then
            printf "${prefix}In '$2', at $3 #$1:\n"
            prefix+="${ABASHED[log:indent]:-  }"
        fi

        while read line
        do
            echo "$prefix$line"
        done
    else
        echo "$prefix$msg$suffix"
        if [ $# -gt 0 ]
        then
            set $ABASHED_LOG_CONTEXT &&
            printf " [in '$2', at $3 #$1]\n"
        else
            echo
        fi
    fi >&2
}

##############################################################################

ABASHED_v0_1:log-if()
{
    local -i max_level="${ABASHED[log-level:${1^^}]:-${1:-0}}"; shift &&
    [ $ABASHED_LOG_LEVEL -gt $max_level ] || ABASHED_v0_1:log "$@"
}

##############################################################################
##############################################################################

ABASHED_v0_1:dump()
{
    local ABASHED_LOG_CONTEXT="$(caller 0)"
    declare -p "$@" | ABASHED_v0_1:log -
}

