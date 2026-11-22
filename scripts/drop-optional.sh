#!/usr/bin/env bash
# Takes the optional patches apply-patches.sh applied back out, newest first,
# so a build that fails with them can be retried without them. Exits 1 when
# none was applied: then there is nothing to retry without.
set -euo pipefail

[ -s .zapfastx-optional ] || exit 1
# Newest first; macOS has no tac.
awk '{ lines[NR] = $0 } END { for (i = NR; i > 0; i--) print lines[i] }' .zapfastx-optional |
  while read -r patch; do
    git apply --reverse --verbose "$patch"
    echo "::warning title=Optional patch dropped::$(basename "$patch") broke this build, so the release goes without it until patches/optional is updated"
  done
: > .zapfastx-optional
