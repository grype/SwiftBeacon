#!/bin/zsh

GIT_DIR=$(git rev-parse --show-toplevel)
SCRIPTS_DIR="${GIT_DIR}/scripts/git-hooks/pre-commit"
alias -g ERR='>&2'

echo ERR
echo "Running pre-commit hooks..." ERR

for i in $SCRIPTS_DIR/**/*(.); do
  echo ERR
  echo "> ${i:t}" ERR
  $i || return 1
done
