#!/usr/bin/env bash
# Applies the patches in $1, in order, to the upstream checkout in the current
# directory. One at a time, since later patches build on earlier ones. A patch
# whose change upstream already has (it reverses cleanly) is skipped with a
# warning, so a change upstream adopts doesn't stop the build; a patch that
# neither applies nor reverses fails, showing why.
#
# Then the optional patches in $1/optional: looks rather than fixes, which a
# release can go without. One that no longer applies is skipped with a
# warning instead of stopping the build, and the ones applied are listed in
# .zapfastx-optional, so scripts/drop-optional.sh can take them out again if
# the build fails with them.
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

: > .zapfastx-optional
for patch in "$1"/optional/*.patch; do
  [ -e "$patch" ] || continue
  name=$(basename "$patch")
  if git apply --check "$patch" 2>/dev/null; then
    git apply --verbose "$patch"
    realpath "$patch" >> .zapfastx-optional
  else
    echo "::warning title=Optional patch skipped::$name no longer applies to this upstream release, so this build goes without it until patches/optional is updated"
  fi
done

# A library fix can't be a patch: it moves when upstream's pin does.
bash "$(dirname "$0")/repin-whatsapp-rust.sh"
