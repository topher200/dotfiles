#!/bin/bash


### setup
cd ~/dev/wordstream2

# generate a custom .pylintrc that points to our /wordstream repo checkout
sed /init-hook/s/wordstream/wordstream2/ ~/.pylintrc > ~/.pylintrc-wordstream2

# that that we received one or two commit ids to test
SHA_1=$1
SHA_2=$2
if [ "$SHA_2" == "" ]; then
    echo 'using stable_db_migration as the origin commit id'
    SHA_2=$1
    SHA_1="stable_db_migration"
fi
if [ "$SHA_1" == "" ] || [ "$SHA_2" == "" ]; then
    echo 'must receive commit-ids to test'
    exit
fi
###



### run pylint
# check out sha #1 and run pylint
git checkout "$SHA_1"
git pull --rebase 2> /dev/null
pylint --output-format parseable server/wordstream/src/wordstream                    --errors-only --rcfile ~/.pylintrc-wordstream2 > ~/pylint-start
pylint --output-format parseable python_shared/webapp_framework/src/webapp_framework --errors-only --rcfile ~/.pylintrc-wordstream2 >> ~/pylint-start
pylint --output-format parseable python_shared/wsframework/src/base_api              --errors-only --rcfile ~/.pylintrc-wordstream2 >> ~/pylint-start
pylint --output-format parseable python_shared/wsframework/src/utils                 --errors-only --rcfile ~/.pylintrc-wordstream2 >> ~/pylint-start
pylint --output-format parseable python_shared/wsframework/src/wsframework           --errors-only --rcfile ~/.pylintrc-wordstream2 >> ~/pylint-start
pylint --output-format parseable client/manager/src/m1                               --errors-only --rcfile ~/.pylintrc-wordstream2 >> ~/pylint-start
pylint --output-format parseable client/manager/src/manager                          --errors-only --rcfile ~/.pylintrc-wordstream2 >> ~/pylint-start

# check out sha #2 and run pylint
git checkout "$SHA_2"
git pull --rebase 2> /dev/null
pylint --output-format parseable server/wordstream/src/wordstream                    --errors-only --rcfile ~/.pylintrc-wordstream2 > ~/pylint-end
pylint --output-format parseable python_shared/webapp_framework/src/webapp_framework --errors-only --rcfile ~/.pylintrc-wordstream2 >> ~/pylint-end
pylint --output-format parseable python_shared/wsframework/src/base_api              --errors-only --rcfile ~/.pylintrc-wordstream2 >> ~/pylint-end
pylint --output-format parseable python_shared/wsframework/src/utils                 --errors-only --rcfile ~/.pylintrc-wordstream2 >> ~/pylint-end
pylint --output-format parseable python_shared/wsframework/src/wsframework           --errors-only --rcfile ~/.pylintrc-wordstream2 >> ~/pylint-end
pylint --output-format parseable client/manager/src/m1                               --errors-only --rcfile ~/.pylintrc-wordstream2 >> ~/pylint-end
pylint --output-format parseable client/manager/src/manager                          --errors-only --rcfile ~/.pylintrc-wordstream2 >> ~/pylint-end
###



### create diffs
# print the diff of the two
diff ~/pylint-start ~/pylint-end > ~/pylint-diff

# print the diff of the two when you take out line numbers
diff --ignore-all-space \
    <(sed -r s/[0-9]\+:/XXX:/ ~/pylint-start) \
    <(sed -r s/[0-9]\+:/XXX:/ ~/pylint-end) \
    > ~/pylint-super-diff

cat ~/pylint-super-diff
###
