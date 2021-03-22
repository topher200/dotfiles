#!/bin/bash

# Takes a filename and a string. Waits for the given string to appear in the
# given log file
string=$1
filename=$2

grep -m 1 "$string" <(tail -f -n 0 "$filename") >/dev/null
