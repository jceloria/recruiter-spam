#!/usr/bin/env bash

SELF=${0##*/} SDIR=${0%/*}
########################################################################################################################
: '
 The MIT License (MIT)

 Copyright © 2019 by John Celoria.

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
######################################################## config ########################################################
# Set some defaults
VERSION=0.1

####################################################### functions ######################################################
# Print usage information
function help() {
cat << EOF
Usage: ${SELF} [OPTION]...
Generate Gmail filter from list of domains

  -h    Display this help message and exit

EOF
    return
}
########################################################################################################################
########################################################################################################################
# Sanity checks
while getopts ":hq" opt; do
    case ${opt} in
        h)  help >&2; exit 1                                            ;;
        \?) echo "Invalid option: -${OPTARG}" >&2                       ;;
        :)  echo "Option -${OPTARG} requires an argument." >&2; exit 1  ;;
    esac
done; shift $((${OPTIND} - 1))

######################################################### main #########################################################

cat <<!!
<?xml version='1.0' encoding='UTF-8'?><feed xmlns='http://www.w3.org/2005/Atom' xmlns:apps='http://schemas.google.com/apps/2006'>
!!

cat list.txt | while read line; do
cat <<!!
    <entry>
        <category term='filter'></category>
        <title>Mail Filter</title>
        <apps:property name='from' value='${line}'/>
        <apps:property name='shouldTrash' value='true'/>
        <apps:property name='sizeOperator' value='s_sl'/>
        <apps:property name='sizeUnit' value='s_smb'/>
    </entry>
!!
done

cat <<!!
</feed>
!!
########################################################################################################################
