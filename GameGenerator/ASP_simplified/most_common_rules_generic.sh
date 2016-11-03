#!/bin/bash
cut -d "(" -f 1 temp2 >  tempG2;  sort tempG2 | uniq -c > tempG3; sort -nr tempG3 > tempG4 
