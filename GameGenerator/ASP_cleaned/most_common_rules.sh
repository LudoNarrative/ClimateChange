#!/bin/bash

clingo "$@" --text > temp; sed -e "s/[0-9]\+/D/g" temp > temp2;  uniq -c temp2 > temp3; sort -nr temp3 > temp4 