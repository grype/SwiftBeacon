#!/bin/zsh

GIT_DIR=$(git rev-parse --show-toplevel)
SCRIPTS_DIR="${GIT_DIR}/scripts/git-hooks/pre-commit"

echo
echo "Running pre-commit hooks..."

for i in $SCRIPTS_DIR/**/*(.); do
  echo
  echo "> ${i:t}" 
  $i || return 1
done
