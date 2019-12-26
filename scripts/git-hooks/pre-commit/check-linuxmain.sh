#!/bin/zsh

RED='\033[0;31m'
CLEAR='\033[0m'
MANIFEST="Tests/BeaconTests/XCTestManifests.swift"

findNewerTests() {
	find Tests/BeaconTests  -type f -iname "*.swift" -newer "${MANIFEST}"
}

isLinuxMainFresh() {
  type -a $tests
  tests=(`find Tests/BeaconTests  -type f -iname "*.swift" -newer "${MANIFEST}"`)
	if [[ ${#tests[@]} -eq 0 ]]; then
    return 0
  else
    return 1
  fi
}

if ! isLinuxMainFresh; then
	echo "${RED}Test files changed!${CLEAR}"
	echo "Update LinuxMain.swift before committing:"
	echo "  make linuxmain"
  echo "or"
  echo "  touch ${MANIFEST}"
	echo
	exit 1
fi
