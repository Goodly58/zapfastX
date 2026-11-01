#!/usr/bin/env bash
# Applies the patches in $1, in order, to the upstream checkout in the current
# directory. One at a time, since later patches build on earlier ones. A patch
# whose change upstream already has (it reverses cleanly) is skipped with a
# warning, so a change upstream adopts doesn't stop the build; a patch that
# neither applies nor reverses fails, showing why.
set -euo pipefail

for patch in "$1"/*.patch; do
  name=$(basename "$patch")
  if git apply --check "$patch" 2>/dev/null; then
    git apply --verbose "$patch"
  elif git apply --reverse --check "$patch" 2>/dev/null; then
    echo "::warning title=Patch already upstream::$name is already in upstream and can be removed from patches/"
  else
    git apply --verbose "$patch"
  fi
done
