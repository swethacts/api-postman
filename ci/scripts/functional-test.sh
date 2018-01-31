#!/usr/bin/env bash
set -e -x
ls -las

if [ -d tests ]; then
	echo "Deleting tests folder"
	chmod 777 tests
	rm -rf tests
fi

echo "Creating tests folder"
mkdir tests

ls -ltr

cd src/test/api

echo "Installing newman ..."
npm install -g newman
echo "Installed newman ..."

newman run collections/git.postman_collection.json --environment collections/newman-env.postman_environment.json --reporters cli,junit,html --reporter-junit-export testresults/unformatted/xmlOut.xml --reporter-html-export testresults/unformatted/htmlOut.html

if [ $? -ne 0 ]; then  
	TEST_FAILURE = 1
fi

python add_attr.py -f testresults/unformatted/*.xml
cd testresults/junit
chmod 777 temp.txt

ls -ltr
rm temp.txt

ls -ltr

cp *.xml ../../../../../tests
ls -ltr

if [ "$TEST_FAILURE" -eq 1 ]; then
	echo "Exiting with exit code 1..."
	exit 1
fi