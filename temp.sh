#!/usr/bin/env bash
set -e -x
ls -las


read -p "Press enter to continue"

TESTDIR="tests"

if [ -d "$TESTDIR" ];
then
	echo "Deleting tests folder"
	chmod 777 tests
	rm -rf tests
fi

#echo "Creating tests folder"
#mkdir tests
#chmod 777 tests

read -p "Press enter to continue"