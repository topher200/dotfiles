#!/bin/bash

ALL=true
while [ ! $# -eq 0 ]
do
    case "$1" in
        --manager | -m)
            MANAGER=true
            ALL=false
            ;;
        --engine | -e)
            ENGINE=true
            ALL=false
            ;;
    esac
    shift
done

# kill the servers, just to make sure they're not running
kill-servers.sh

# for each server, cd into its directory and run it in a new process. we pipe
# its output to /dev/null (and monitor the logs instead). STDERR is still
# printed to console. we use the wordstream virtualenv's python directly
WORDSTREAM_ROOT="/Users/t.brown/dev/wordstream"
WORDSTREAM_PYTHON="/Users/t.brown/.virtualenvs/wordstream/bin/python"

if [ "$ALL" = true ] ; then
    echo "starting tag manager"
    cd "$WORDSTREAM_ROOT/server/tag_manager/src"
    $WORDSTREAM_PYTHON server.py --daemon > /dev/null &

    # landing pages start correctly, but i can't seem to navigate to them.
    # ignoring their existance for now
    # echo "starting landing pages"
    # cd "$WORDSTREAM_ROOT/client/pages/src"
    # $WORDSTREAM_PYTHON server.py --daemon > /dev/null &

    echo "starting kwresearch"
    cd "$WORDSTREAM_ROOT/server/kwresearch/src"
    $WORDSTREAM_PYTHON server.py --daemon > /dev/null &
fi

if [ "$ALL" = true ] || [ "$MANAGER" = true ] ; then
    echo "starting manager, with a delay"
    # we need to wait until engine has started, so we grep the end of the
    # server's logs and start manager as soon as server announces a new
    # "Launched CherryPy". this approach is explained here:
    # http://superuser.com/a/809159
    cd "$WORDSTREAM_ROOT/client/manager/src"
    (grep -m 1 "Launched\ CherryPy" <(tail -f -n 0 /var/log/wordstream/server/debug.log) &&
            $WORDSTREAM_PYTHON auto_reload_server.py --daemon > /dev/null) > /dev/null &
fi

if [ "$ALL" = true ] || [ "$ENGINE" = true ] ; then
    echo "starting engine"
    cd "$WORDSTREAM_ROOT/server/wordstream/src"
    $WORDSTREAM_PYTHON auto_reload_server.py --daemon > /dev/null &
fi

if [ "$ALL" = true ] ; then
    echo "starting SWF"
    cd "$WORDSTREAM_ROOT/server/wordstream/src"
    env no_proxy='*' $WORDSTREAM_PYTHON swf.py conf/ REPORTING DECIDER 1 > /dev/null &
    env no_proxy='*' $WORDSTREAM_PYTHON swf.py conf/ REPORTING ACTIVITY_WORKER 2 > /dev/null &
    env no_proxy='*' $WORDSTREAM_PYTHON swf.py conf/ ADWORDS_QUICKSTART DECIDER 1 > /dev/null &
    env no_proxy='*' $WORDSTREAM_PYTHON swf.py conf/ ADWORDS_QUICKSTART ACTIVITY_WORKER 2 > /dev/null &

    echo "starting Swarm"
    env no_proxy='*' $WORDSTREAM_PYTHON swarm.py conf/ 1 medium_priority_queue PERMANENT DEBUG > /dev/null &
fi
