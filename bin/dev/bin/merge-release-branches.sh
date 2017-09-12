#!/bin/bash

git checkout stable_db_migration
git pull # POSSIBLY DANGEROUS!
# look for all remote branches. get just the release-20** ones. awk the output
# so we just get the 'branch name' column
branches=`git ls-remote origin | grep refs/heads | grep release-20.. | awk '{print $1}'`
for branch in $branches; do
    echo "trying to merge commit id $branch"
    git merge $branch
done
