#!/bin/bash

# PREREQ: must have git installed and configured for your GitHub account

# use this file to clone all your students' repositories for an assignment, add/modify/remove a file to each repo, and commit and push those changes
# <op> is add or rm (add will add or modify the file, rm will remove the file)
# <dir> is the name of the directory of the template repository used for the assignment (it needs to already be cloned to your local machine)
#   Do not include the path to this directory as that should be set in the BASE variable
# <filename> is the filepath of the file in the repository that you want to copy to your students' repositories
# <repo> is the prefix GitHub Classroom gives each student repository for this assignment
# <period> is the class period you want to add a file for

# verify arguments
if [ $# != 5 ]; then
  echo "USAGE: change-file.sh <op> <dir> <filename> <repo> <period>"
  exit 1
fi

# store command-line arguments
OP=$1
DIR=$2
FILE=$3
REPO=$4
PERIOD=$5

# verify OP is valid
if [ ${OP} = "add" ]; then
  MSG="added/modified ${FILE}"
elif [ ${OP} = "rm" ]; then
  MSG="removed ${FILE}"
else
  echo "ERROR: not a valid operation"
  exit 1
fi

# directory on local machine that has GitHub repositories
BASE=""
# GitHub organization used for GitHub Classroom
ORG=""

# list of github usernames per class period
usernames1=()
usernames2=()
usernames3=()
usernames4=()
usernames5=()
usernames6=()
usernames7=()

# determine right usernames to use
gitnames=()

case "$PERIOD" in
  "1")
    gitnames=${usernames1[*]}
    ;;
  "2")
    gitnames=${usernames2[*]}
    ;;
  "3")
    gitnames=${usernames3[*]}
    ;;
  "4")
    gitnames=${usernames4[*]}
    ;;
  "5")
    gitnames=${usernames5[*]}
    ;;
  "6")
    gitnames=${usernames6[*]}
    ;;
  "7")
    gitnames=${usernames7[*]}
    ;;
  *)
    echo "ERROR: not a valid class period"
    exit 1
    ;; 
esac

# for debugging if you need to work on just one student repo
#gitnames=""

# add/modify file
cd ${BASE}
for name in $gitnames; do
  echo "Working on ${name}"
  git clone https://github.com/${ORG}/${REPO}-${name}.git > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "  WARNING: could not clone repo ${REPO}-${name}"
    continue
  fi
  echo "  cloned repo ${REPO}-${name}"
  cd ${BASE}/${REPO}-${name}
  if [ ${OP} = "add" ]; then
    cp ${BASE}/${DIR}/${FILE} ./${FILE}
  fi
  git ${OP} ${FILE} > /dev/null 2>&1
  git commit -m "${MSG}" > /dev/null 2>&1
  git push > /dev/null 2>&1
  echo "  ${MSG} for ${name}"
  cd ${BASE} > /dev/null
  rm -rf ${BASE}/${REPO}-${name}
  echo "  removed repo ${REPO}-${name}"
done
