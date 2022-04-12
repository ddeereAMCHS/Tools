#!/bin/bash

# PREREQ: must have git installed and configured for your GitHub account

# use this file to clone all your students' repositories for an assignment, add/modify/remove a file to each repo, and commit and push those changes
# <op> is add or rm (add will add or modify the file, rm will remove the file)
# <dir> is the name of the directory of the template repository used for the assignment (it needs to already be cloned to your local machine)
#   Do not include the path to this directory as that should be set in the BASE variable
# <filename> is the filepath of the file in the repository that you want to copy to your students' repositories
# <repo> is the prefix GitHub Classroom gives each student repository for this assignment
# <period> is the class period for which you want to change a file


# directory on local machine that has GitHub repositories
BASE=""
# GitHub organization used for GitHub Classroom
ORG=""

# verify arguments
if [ $# != 5 ]; then
  echo "USAGE: change-file.sh <op> <dir> <filename> <repo> <period>" >&2
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
  echo "ERROR: not a valid operation" >&2
  exit 1
fi

# verify DIR exists on local machine
if [ ! -e ${BASE}/${DIR} ]; then
  echo "ERROR: ${DIR} does not exist" >&2
  exit 1
fi
if [ ! -d ${BASE}/${DIR} ]; then
  echo "ERROR: ${DIR} is not a valid directory" >&2
  exit 1
fi

# verify PERIOD is numeric
re='^[0-9]$'
if ! [[ $PERIOD  =~ $re ]]; then
  echo "ERROR: period must be a number between 0 and 9 (inclusive)" >&2
  exit 1
fi

# verify FILE exists on local machine
if [ ! -e ${BASE}/${DIR}/${FILE} ]; then
  echo "ERROR: ${DIR}/${FILE} does not exist" >&2
  exit 1
fi

# list of github usernames per class period
# enclose each username in quotes and separate with spaces
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
    echo "ERROR: not a valid class period" >&2
    exit 1
    ;; 
esac

# for debugging if you need to work on just one student repo
#gitnames=""

# make sure local repo is up to date
cd ${BASE}/${DIR}
git pull > /dev/null 2>&1

# cleanup function for exiting early
function cleanup() {
  cd ${BASE}
  rm -rf ${BASE}/${REPO}-*
  echo "Cleaned up files before exiting"
}

trap cleanup EXIT

# change file
cd ${BASE}
for name in $gitnames; do
  echo "Working on ${name}"
  # clone repo
  git clone https://github.com/${ORG}/${REPO}-${name}.git > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "  WARNING: could not clone repo ${REPO}-${name}"
    continue
  fi
  echo "  cloned repo ${REPO}-${name}"
  # copy file
  cd ${BASE}/${REPO}-${name}
  if [ ${OP} = "add" ]; then
    tmp=${FILE}
    # create directories if needed
    while [[ "${tmp}" == *\/* ]]; do
      dirtomake=$(echo $tmp | cut -d'/' -f 1)
      tmp=${tmp:${#dirtomake}+1}
      if [ ! -d ${dirtomake} ]; then
        mkdir ${dirtomake}
      fi
      cd ${dirtomake}
    done
    cp ${BASE}/${DIR}/${FILE} .
  fi
  # add, commit, and push changes
  cd ${BASE}/${REPO}-${name}
  git add -A > /dev/null 2>&1
  git commit -m "${MSG}" > /dev/null 2>&1
  pushOutput=$(git push 2>&1)
  # check if file was changed or not
  if [[ ${pushOutput} = "Everything up-to-date" ]]; then
    echo "  no changes for ${name}"
  else
    echo "  ${MSG} for ${name}"
  fi
  cd ${BASE} > /dev/null
  # remove cloned repo
  rm -rf ${BASE}/${REPO}-${name}
  echo "  removed repo ${REPO}-${name}"
done
