#!/bin/bash

# quit the script immediately on error
set -e

echo 'WARNING! you should be on the "github" branch HEAD. this will push HEAD to github (watch for secrets!) AND THEN force push to google. <enter> to proceed'
git log --oneline --decorate=full | head
read -n 1

echo 'push HEAD to github repo'
git push github HEAD:master

echo 'rebase google/master branch on top of HEAD'
git checkout master
git rebase github/master

echo 'FORCE PUSH master to google repo'
git push origin HEAD:master --force
