#!/bin/bash

# quit the script immediately on error
set -e

echo 'WARNING! this will push HEAD to github. <enter> to proceed'
git log --oneline --decorate=full | head
read -n 1

echo 'push current branch to github repo'
git push github HEAD:master

echo 'rebase google/master branch on top of HEAD'
git checkout master
git rebase github/master
echo 'push google to google repo'
git push origin HEAD:master
