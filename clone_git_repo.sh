# Modify file using python script https://github.com/myrepo/blob/master/yml_parser.py
# Use hub to create PR https://hub.github.com/

#!/bin/bash

# verify hub available
git --version

FILE_NAME=.drone.yml

export HOME_DIR=/Users/khill1/Documents/dtr_to_art
echo $HOME_DIR
cd $HOME_DIR

# set directory to clone projects to
export MOD_REPO=$1
echo $MOD_REPO

export NEW_BRANCH=DTR_to_Artifactory
echo $NEW_BRANCH

export ORGANIZATION=XYZ
if [ $# -eq 2 ]; then
  export ORGANIZATION=$2
fi
echo $ORGANIZATION

export SOURCE_BRANCH=master
if [ $# -eq 3 ]; then
  export SOURCE_BRANCH=$3
fi
echo $SOURCE_BRANCH

export INNER_DIR=
if [ $# -eq 4 ]; then
  export INNER_DIR=$4
fi
echo $INNER_DIR

# get source
git clone git@github.com:$ORGANIZATION/$MOD_REPO.git
cd $MOD_REPO
ls -la

# copy master branch to create new branch
git checkout -b $NEW_BRANCH $SOURCE_BRANCH

# push the new branch to GitHub
git push --set-upstream origin $NEW_BRANCH
git branch

cd $HOME_DIR/$MOD_REPO/$INNER_DIR
pwd
# Run script to edit $FILE_NAME
python $HOME_DIR/yml_parser.py
cat $FILE_NAME
git status

# add the file you’ve edited to your new branch
git add $FILE_NAME
git status
cd $HOME_DIR/$MOD_REPO

# add comment and push
git commit -am "Switching from DTR to Artifactory"
git status
git push

# whitelist GitHub
git config --global --add hub.host github.com

# create pull request with title
hub pull-request -F $HOME_DIR/PR_msg.txt



# use this if comment not added in above step
# hub pull-request -m "Switching from DTR to Artifactory"

# example results - username/pswd only needed 1st time per terminal session
# github.com username: khill1
# github.com password for khill1 (never stored):
# https://github.com/myrepo/pull/175
