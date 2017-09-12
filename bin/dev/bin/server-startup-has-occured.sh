#!/bin/bash

# Returns after server startup has happened. Server startup is defined as when
# "RoutesMapHandler" or "CherryPy" log message hits the Engine logs.

# From http://stackoverflow.com/a/246128
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# wait for line in Engine
$ROOT_DIR/wait-for-log-message.sh "RoutesMapHan\|CherryPy" /var/log/wordstream/server/debug.log

# wait a few ms to let the server start up completely. determined emperically
# TODO: this is weird because there seems to be dupes of the above messages in
# Engine logs. we need to find a single log message that occurs when you restart
# engine, or restart manager, or restart both
sleep 5
