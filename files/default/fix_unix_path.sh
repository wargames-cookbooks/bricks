#!/bin/sh
#
# This script is used to fix unix path for require_once and include_once statement.
#
# It's required for following bricks's codenames:
# - Raidak
# - Lachen
# - Punpun
# - Torsa
# - Feni
# - Betwa
# - Narmada
#

if [ $# -ne 1 ]; then
    echo >&2 "Missing bricks path as first argument"
    exit 1
fi

LC_ALL=en_US.UTF-8
LC_CTYPE=en_US.UTF-8

bricks_path=$1

find $bricks_path -name "*.php" -exec \
    sed -ri 's/\\([a-Z]{5,20})/\/\1/g' {} \;
