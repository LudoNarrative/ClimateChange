#!/bin/bash

clingo "$@" --text | sed -e "s/[0-9]\+/D/g" | sort | uniq -c | sort -nr | head
