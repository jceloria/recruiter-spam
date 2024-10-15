#!/usr/bin/env bash

SELF=${0##*/} SDIR=${0%/*}
# -------------------------------------------------------------------------------------------------------------------- #
: '
 The MIT License (MIT)

 Copyright © 2021 by John Celoria.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

'
# Set some defaults -------------------------------------------------------------------------------------------------- #
VERSION=0.2

BLOCK_LIST=${BLOCK_LIST:-list.txt}
OUTPUT_FILE=${OUTPUT_FILE:-~/.gmailctl/config.jsonnet}

# Functions ---------------------------------------------------------------------------------------------------------- #
function help() {
cat << EOF
Usage: ${SELF} [OPTION]...
Generate a Gmail filter from a list of domains

  -h, --help     Display this help message and exit
  -l, --list     The list of domains/emails to read (default: ${BLOCK_LIST})
  -o, --outfile  The output file name (default: ${OUTPUT_FILE})

EOF
    return
}

# -------------------------------------------------------------------------------------------------------------------- #
function log() {
    local level levels=(notice warning crit)
    level="+($(IFS='|';echo "${levels[*]}"))"

    shopt -s extglob; case ${1} in
        ${level}) level=${1}; shift ;;
        *) level=notice ;;
    esac; shopt -u extglob

    [[ -z ${RETVAL} ]] && { for RETVAL in "${!levels[@]}"; do
        [[ ${levels[${RETVAL}]} = "${level}" ]] && break
    done }

    logger -s -p ${level} -t "[${SELF}:${FUNCNAME[1]}()]" -- $@;
}

# -------------------------------------------------------------------------------------------------------------------- #
function die() { local retval=${RETVAL:-$?}; log "$@"; exit ${retval}; }

# -------------------------------------------------------------------------------------------------------------------- #
function generate-jsonnet() {
cat << EOF
local spam = {
  or: [
EOF

    while read line; do
        echo '    { from: "'${line}'" },'
    done < <(<${BLOCK_LIST})

cat << EOF
  ],
};
{
  version: 'v1alpha3',
  rules: [
    {
      filter: spam,
      actions: { delete: true },
    },
  ],
}
EOF
}

# Sanity checks ------------------------------------------------------------------------------------------------------ #
while getopts ":hl:o:-:" OPT; do
    if [[ "${OPT}" = "-" ]]; then
        OPT="${OPTARG%%=*}"
        OPTARG="${OPTARG#$OPT}"
        OPTARG="${OPTARG#=}"
    fi
    case "${OPT}" in
        h|help)     help >&2; exit 1                                        ;;
        l|list)     BLOCK_LIST=${OPTARG}                                    ;;
        o|outfile)  OUTPUT_FILE=${OPTARG}                                   ;;
        ??*)        RETVAL=2; die "Invalid short option: -${OPT}"           ;;
        \?)         RETVAL=3; die "Invalid long option: --${OPT}"           ;;
        :)          RETVAL=4; die "Option -${OPTARG} requires an argument." ;;
    esac
done; shift $((OPTIND-1))

req_progs=(gmailctl)
for p in ${req_progs[@]}; do
    hash "${p}" 2>&- || \
    { die "Required program \"${p}\" not found in \${PATH}."; }
done

# main --------------------------------------------------------------------------------------------------------------- #

export LANG=C.UTF-8

[[ -e ${OUTPUT_FILE} ]] && read -p "Overwrite, ${OUTPUT_FILE} [y/N]?: " x

case ${x} in y*|Y*) overwrite=1 ;; *) overwrite=0 ;; esac

if [[ -e ${OUTPUT_FILE} ]] && [[ ${overwrite} -eq 0 ]]; then
    die 'Exiting...'
fi

generate-jsonnet | tee ${OUTPUT_FILE}

# -------------------------------------------------------------------------------------------------------------------- #
