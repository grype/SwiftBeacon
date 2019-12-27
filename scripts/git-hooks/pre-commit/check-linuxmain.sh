#!/bin/zsh

RED='\033[0;31m'
CLEAR='\033[0m'

hasTestCaseChanges() {
  ! git diff --quiet Tests/BeaconTests/Test\ Cases
}

if hasTestCaseChanges; then
	echo "${RED}Test files changed!${CLEAR}"
	echo "Update LinuxMain.swift before committing:"
	echo "  make linuxmain"
  echo "or"
  echo "  touch ${MANIFEST}"
	echo
	exit 1
fi
