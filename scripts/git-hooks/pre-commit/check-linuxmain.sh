#!/bin/zsh

RED='\033[0;31m'
CLEAR='\033[0m'

hasTestCaseChanges() {
  ! git diff --quiet Tests/BeaconTests/Test\ Cases
}

if hasTestCaseChanges; then
	echo "${RED}TestCase changes detected!${CLEAR}"
	echo "Be sure to update LinuxMain.swift with:"
	echo "  make linuxmain"
	echo
fi
