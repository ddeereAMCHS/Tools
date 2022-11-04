#! /bin/bash

# PREREQ: must have git installed and configured for your GitHub account
#         your personal access token needs to have workflow scope enabled

# directory on local machine that has GitHub repositories
BASE=""

if [ $# != 1 ]; then
  echo "USAGE: add-blank-tests.sh <dir>"
  exit 1
fi

DIR=$1

# verify DIR exists on local machine
if [ ! -e ${BASE}/${DIR} ]; then
  echo "ERROR: ${DIR} does not exist"
  exit 1
fi
if [ ! -d ${BASE}/${DIR} ]; then
  echo "ERROR: ${DIR} is not a valid directory"
  exit 1
fi

# make sure local repo is up to date
cd ${BASE}/${DIR}
git pull > /dev/null 2>&1

# make .github directory
if [ ! -d ".github" ]; then
  mkdir .github
fi
cd .github

# make workflows directory
if [ ! -d "workflows" ]; then
  mkdir workflows
fi
cd workflows

# create classroom.yml file
FILE="classroom.yml"
rm ${FILE} > /dev/null 2>&1
touch ${FILE}
echo "name: GitHub Classroom Workflow" >> ${FILE}
echo "" >> ${FILE}
echo "on: [push]" >> ${FILE}
echo "" >> ${FILE}
echo "jobs:" >> ${FILE}
echo "  build:" >> ${FILE}
echo "    name: Autograding" >> ${FILE}
echo "    runs-on: ubuntu-latest" >> ${FILE}
echo "    steps:" >> ${FILE}
echo "      - uses: actions/checkout@v2" >> ${FILE}
echo "      - uses: education/autograding@v1" >> ${FILE}

# make workflows directory
cd ..
if [ ! -d "classroom" ]; then
  mkdir classroom
fi
cd classroom

# create autograding.json file
FILE="autograding.json"
rm ${FILE} > /dev/null 2>&1
touch ${FILE}
echo "{" >> ${FILE}
echo "  \"tests\": [" >> ${FILE}
echo "   { " >> ${FILE}
echo "      \"name\": \"\"," >> ${FILE}
echo "      \"setup\": \"javac !!.java\"," >> ${FILE}
echo "      \"run\": \"java !!\"," >> ${FILE}
echo "      \"input\": \"\"," >> ${FILE}
echo "      \"output\": \"\"," >> ${FILE}
echo "      \"comparison\": \"included|regex\"," >> ${FILE}
echo "      \"timeout\": 10," >> ${FILE}
echo "      \"points\": null" >> ${FILE}
echo "    }" >> ${FILE}
echo "  ]" >> ${FILE}
echo "}" >> ${FILE}

# commit and push changes
cd ../..
git add .github/classroom/autograding.json > /dev/null 2>&1
git add .github/workflows/classroom.yml > /dev/null 2>&1
git commit -m "added autograding files" > /dev/null 2>&1
# check if files were changed or not
pushOutput=$(git push 2>&1)
if [[ ${pushOutput} = "Everything up-to-date" ]]; then
  echo "no changes for ${DIR}"
else
  echo "added autograding files for ${DIR}"
fi

cd ..

