#!/usr/bin/env bash
declare _ACORN="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/a.corn.bash" &&
declare -Ag ABASHED && [ "${ABASHED[$_ACORN]:+_}" ] || . "$_ACORN" && 
if [ "${BASH_SOURCE[1]}" ]
then "ABASHED_v0_1:as-source" "$@"
else "ABASHED_v0_1:main" "$@"; fi
