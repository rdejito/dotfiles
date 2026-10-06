#!/bin/bash

df -h / | awk 'NR==2 {
    gsub(/G/, " GiB", $3)
    gsub(/G/, " GiB", $2)
    printf "%%{F#ff1744}DISK%%{F-} %s / %s", $3, $2
}'
