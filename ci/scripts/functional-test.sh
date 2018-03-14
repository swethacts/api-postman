#!/usr/bin/env bash
set -e -x
ls -las

PASSED_TESTS=1
TOTAL_TESTS=1

#TESTDIR="tests"
#if [ -d "$TESTDIR" ]; then	
#	chmod 777 tests
#	rm -rf tests
#	mkdir tests
#fi

if [ -f tests ]; then
    chmod 777 tests
    rm tests
    echo "Deleted the file"
fi

if [ -d tests ]; then
    chmod -R 777 tests
    rm -rf tests
    echo "Deleted the folder"
fi


ls -las
mkdir tests
ls -las

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


cd ../../../../../
pwd
cd tests
ls -ltr

#if [ "$TEST_FAILURE" -eq 1 ]; then
#	echo "Exiting with exit code 1..."
#	exit 1
#fi



THRESHOLD=$API_TEST_THRESHOLD
echo "Threshold set for Pass Rate is "$THRESHOLD
PASSED_TESTS_PERCENT=$((PASSED_TESTS*100))
PASS_RATE=$(( PASSED_TESTS_PERCENT / TOTAL_TESTS ))
echo "Pass Rate is "$PASS_RATE

if [ "$PASS_RATE" -ge "$THRESHOLD" ]
then
	echo "Pass Rate:"$PASS_RATE "is greater than or equal to expected Threshold:"$THRESHOLD ".ci-cd pipeline will continue to execute further"	
else
	echo "Pass Rate:"$PASS_RATE "is less than expected Threshold:"$THRESHOLD ".ci-cd pipeline will not continue to execute further"
	exit 1
fi