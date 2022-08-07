
##############################################################################
##############################################################################

ABASHED_v0_1:boot()
{
    A="${!A}"
    A[version]='0.1'
    A[corn]="${ASCRIPT[:script:file]}"
    A[dir]="${ASCRIPT[:script:dir]}"

    A[@new-module]="$A:new-module"
    A[@script]="$A:script"

    ABASHED["${!A}"]="${!A}"
    ABASHED["${A[version]}"]="${!A}"

    A[log]='ABASHED_LOG'
    ABASHED[log]='ABASHED_LOG'
    [ "${ABASHED_LOG_LEVEL:+_}" ] || declare -gi ABASHED_LOG_LEVEL=0
    [ "${ABASHED[log-level:DEBUG]}" ] || ABASHED[log-level:DEBUG]=-200
    [ "${ABASHED[log-level:VERBOSE]}" ] || ABASHED[log-level:VERBOSE]=-100
    [ "${ABASHED[log-level:INFO]}" ] || ABASHED[log-level:INFO]=0
    [ "${ABASHED[log-level:WARNING]}" ] || ABASHED[log-level:WARNING]=100
    [ "${ABASHED[log-level:ERROR]}" ] || ABASHED[log-level:ERROR]=200
    [ "${ABASHED[log-level:FATAL]}" ] || ABASHED[log-level:FATAL]=300
    [ "${ABASHED[log-level:ALWAYS]}" ] || ABASHED[log-level:ALWAYS]=999

    while "$A:new-module" abashed "${!A}"
    do
        local -n abashed="${!AMODULE}"
        "$A:script-has-fn" "${A[dir]}/a.log.bash" \
            "$A:fatal" "$A:log" "$A:dump" "$A:alert"

        ABASHED_v0_1:log-if()
        {
            local -i level="${ABASHED[log-level:${1^^:-}]:-${1:-0}}"
            [ "$ABASHED_LOG_LEVEL" -gt "$level" ] ||
            ABASHED_v0_1:script "${ABASHED_v0_1[dir]}/a.log.bash" \
                "${FUNCNAME[0]}" "$@"
        }

        ABASHED_v0_1:debug()
        {
            [ "$ABASHED_LOG_LEVEL" -gt "${ABASHED[log-level:DEBUG]}" ] ||
            ABASHED_v0_1:script "${ABASHED_v0_1[dir]}/a.log.bash" \
                "${FUNCNAME[0]}" "$@"
        }

        ABASHED_v0_1:verbose()
        {
            [ "$ABASHED_LOG_LEVEL" -gt "${ABASHED[log-level:VERBOSE]}" ] ||
            ABASHED_v0_1:script "${ABASHED_v0_1[dir]}/a.log.bash" \
                "${FUNCNAME[0]}" "$@"
        }

        ABASHED_v0_1:info()
        {
            [ "$ABASHED_LOG_LEVEL" -gt "${ABASHED[log-level:INFO]}" ] ||
            ABASHED_v0_1:script "${ABASHED_v0_1[dir]}/a.log.bash" \
                "${FUNCNAME[0]}" "$@"
        }

        ABASHED_v0_1:warning()
        {
            [ "$ABASHED_LOG_LEVEL" -gt "${ABASHED[log-level:WARNING]}" ] ||
            ABASHED_v0_1:script "${ABASHED_v0_1[dir]}/a.log.bash" \
                "${FUNCNAME[0]}" "$@"
        }

        ABASHED_v0_1:error()
        {
            [ "$ABASHED_LOG_LEVEL" -gt "${ABASHED[log-level:ERROR]}" ] ||
            ABASHED_v0_1:script "${ABASHED_v0_1[dir]}/a.log.bash" \
                "${FUNCNAME[0]}" "$@"
        }

    done
}

##############################################################################

ABASHED_v0_1:as-main()
{
    local -n A='ABASHED_v0_1' &&
    local script="$1"; shift &&
    . "$script" "$@"
}

##############################################################################

ABASHED_v0_1:as-source()
{
    if [ $# -gt 0 ]
    then
        local -n A='ABASHED_v0_1' &&
        local fn="$1"; shift &&
        "$fn" "$@"
    fi
}

##############################################################################
##############################################################################

ABASHED_v0_1:script()
{
    local -n A='ABASHED_v0_1' &&
    local source="$1"; shift &&
    local file="$(readlink -f "${source:-${BASH_SOURCE[1]}}")" &&
    local -n scriptref="A[script:$file]" &&
    [ "${scriptref+_}" = _ ] && return 0 ||

    if [ ! "${scriptref:+_}" ]
    then
        local -n ASCRIPT="${A}__SCRIPT_$(( A[lastidx]++ ))"
        scriptref="${!ASCRIPT}"
        declare -gA "${!ASCRIPT}"
        ASCRIPT[:script:file]="${BASH_SOURCE[1]}"
        ASCRIPT[:script:line]="${BASH_LINENO[1]}"
        ASCRIPT[:script:dir]="$(dirname "${ASCRIPT[:script:file]}")"
        [ ! "$source" ] || . "$file"
        ASCRIPT[:script:exit]="$?"
    fi &&

    if [ $# -gt 0 ]
    then
        local -n ASCRIPT="${scriptref}" &&
        local fn="$1"; shift &&
        "$fn" "$@" || return $?
    fi

}

##############################################################################

ABASHED_v0_1:script-has-fn()
{
    local script="$1"; shift &&
    [ -r "$script" ] || { echo >&2 "Invalid: $script"; exit 65; } &&
    eval "$(
        for fn in "$@";
        do
            echo "function $fn { '$A:script' '$script' '$fn' \"\$@\"; }";
        done
    )"
}

##############################################################################

ABASHED_v0_1:new-module()
{
    local -n A='ABASHED_v0_1' &&
    local module="$1"; shift &&
    local -n modref="A[module:$module]" &&

    [ ! "${modref:+_}" ] && 
    {
        declare -gn AMODULE="${2:-${A}_MODULE_$(( A[lastidx]++ ))}" &&
        modref="${!AMODULE}" &&
        declare -gA "${!AMODULE}" &&
        AMODULE[:module:name]="$module" &&
        AMODULE[:module:file]="${BASH_SOURCE[1]}" &&
        AMODULE[:module:dir]="$(dirname "${AMODULE[:module:file]}")"
        AMODULE[:module:line]="${BASH_LINENO[1]}"
    }
}

##############################################################################
##############################################################################

ABASHED_v0_1:do()
{
    local -n ASELF="$1" &&
    local AMETHOD="$2" &&
    local -n ATYPE="$self" &&
    local FN="${ATYPE[@$AMETHOD]}" &&
    [ "$FN" ] || ABASHED_v0_1:method-not-found "$@" && "$FN" "$@"
}

##############################################################################
##############################################################################

ABASHED_v0_1:log-level()
{
    ABASHED_LOG_LEVEL="${ABASHED[log-level:"${1^^}"]:-$1}"
}

##############################################################################
##############################################################################

declare -gA ABASHED_v0_1
ABASHED_v0_1:script '' ABASHED_v0_1:boot

