#!/bin/bash

# Iterate through databases 0 to 19
for db in {0..19}; do
	echo "Scanning database $db..."
	redis-cli -n "$db" --scan --pattern '*'
done
