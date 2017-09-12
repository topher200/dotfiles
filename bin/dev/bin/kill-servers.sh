#!/bin/bash

ps aux | \
    grep -e "server\.py" -e "swf\.py" -e "swarm\.py" | \
    grep -v "grep" | \
    awk '{ print $2 }' | \
    xargs kill -15
