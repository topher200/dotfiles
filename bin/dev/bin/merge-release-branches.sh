#!/bin/bash

git checkout stable_db_migration
git pull # POSSIBLY DANGEROUS!

printf '\n--- starting merges now. everything commit below this point should print "Already up-to-date." ---\n\n'

# look for all remote branches. get just the release-20** ones. awk the output
# so we just get the 'branch name' column. we use a crazy regex so we don't get
# branch names like 'release-2018-01-01-migrators'.
branches=`git ls-remote origin |
          grep refs/heads |
          grep 'refs/heads/release-[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$' |
          sed -e 's/^.*refs/heads//'`
for branch in $branches; do
    echo "trying to merge commit id $branch"
    git merge $branch
done
