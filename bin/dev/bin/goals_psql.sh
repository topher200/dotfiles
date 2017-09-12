#!/bin/sh

DAYS_BACKWARD=5;\
GOAL_ID=$(psql postgresql://aws:jUuya78hjy@dev-db1.wordstream.com/wordstream_dev-ppc-seven -t -c "SELECT id FROM goal_definition WHERE status = 'ACTIVE' ORDER BY id DESC LIMIT 1;");\
echo "Goal id: $GOAL_ID";\
echo 'BEFORE';\
psql postgresql://aws:jUuya78hjy@dev-db1.wordstream.com/wordstream_dev-ppc-seven -c "SELECT * FROM goal_definition WHERE id = $GOAL_ID;";\
echo "Press any key to continue or ctrl-c to cancel";\
read -n 1;\
echo "\nManipulating goal backwards in time";\
psql postgresql://aws:jUuya78hjy@dev-db1.wordstream.com/wordstream_dev-ppc-seven -c "UPDATE goal_definition SET start_datetime = start_datetime - INTERVAL '$DAYS_BACKWARD' DAY WHERE id = $GOAL_ID;";\
echo 'AFTER';\
psql postgresql://aws:jUuya78hjy@dev-db1.wordstream.com/wordstream_dev-ppc-seven -c "SELECT * FROM goal_definition WHERE id = $GOAL_ID;";


NEW_TARGET_VALUE=10000000;\
GOAL_ID=$(psql postgresql://aws:jUuya78hjy@dev-db1.wordstream.com/wordstream_dev-ppc-seven -t -c "SELECT id FROM goal_definition WHERE status = 'ACTIVE' ORDER BY id DESC LIMIT 1;");\
echo "Goal id: $GOAL_ID";\
echo 'BEFORE';\
psql postgresql://aws:jUuya78hjy@dev-db1.wordstream.com/wordstream_dev-ppc-seven -c "SELECT * FROM goal_definition WHERE id = $GOAL_ID;";\
echo "Press any key to continue or ctrl-c to cancel";\
read -n 1;\
echo "Manipulating goal's target value";\
psql postgresql://aws:jUuya78hjy@dev-db1.wordstream.com/wordstream_dev-ppc-seven -c "UPDATE goal_definition SET target_value = $NEW_TARGET_VALUE WHERE id = $GOAL_ID;";\
echo 'AFTER';\
psql postgresql://aws:jUuya78hjy@dev-db1.wordstream.com/wordstream_dev-ppc-seven -c "SELECT * FROM goal_definition WHERE id = $GOAL_ID;";
