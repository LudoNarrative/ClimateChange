#!/bin/bash

sed -e "s/\:\-.*//g" temp2 >  tempG2;  uniq -c tempG2 > tempG3; sort -nr tempG3 > tempG4 
