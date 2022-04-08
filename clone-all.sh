#!/bin/bash

# PREREQ: must have git installed and configured for your GitHub account

# use this file to clone all your students' repositories for an assignment
# <repo> is the prefix GitHub Classroom gives each student repository for this assignment
# <period> is the class period you want to add a file for

# verify arguments
if [ $# != 2 ]; then
  echo "USAGE: clone-all.sh <repo> <period>"
  exit 1
fi

# store command-line arguments
REPO=$1
PERIOD=$2

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
mkdir ${REPO}
cd ${REPO}
for name in $gitnames; do
  echo "Working on ${name}"
  git clone https://github.com/${ORG}/${REPO}-${name}.git > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "  WARNING: could not clone repo ${REPO}-${name}"
    continue
  fi
  echo "  cloned repo ${REPO}-${name}"
done
cd ${BASE}