#!/bin/zsh

GIT_DIR=$(git rev-parse --show-toplevel)
SCRIPTS_DIR="${GIT_DIR}/scripts/git-hooks/pre-commit"

for i in $SCRIPTS_DIR/**/*(.); do
  $i || return 1
done
