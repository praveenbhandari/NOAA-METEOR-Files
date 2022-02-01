#!/bin/bash

# $1 = Satellite Name
# $2 = Frequency
# $3 = FileName base
# $4 = TLE File
# $5 = EPOC start time
# $6 = Time to capture

sudo timeout $6 rtl_fm -f ${2}M -s 48k -g 0 -p 68 -E dc -A fast -F 9 - | sox -t raw -r 48000 -es -b16 -c1 -V1 - $3.wav rate 11025

PassStart=`expr $5 + 90`

if [ -e $3.wav ]
  then
    /usr/local/bin/wxmap -T "${1}" -H $4 -p 0 -l 0 -o $PassStart ${3}-map.png

    /usr/local/bin/wxtoimg -m ${3}-map.png -e MSA $3.wav $3.png
fi