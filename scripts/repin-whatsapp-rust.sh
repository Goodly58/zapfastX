#!/usr/bin/env bash
# Moves whatsapp-rust to Goodly58/whatsapp-rust 6c6d494: upstream's pin,
# oxidezap/whatsapp-rust 719f294, plus #2077 (6964809) and a commit of ours
# that asks for a group's unverified members in one request. Before a device's
# first send to a group, the library checks each member's primary identity key.
# Upstream asks one member at a time, about three a second, so a group of a
# thousand can hold a message on the clock for minutes; #2077 asks eight at a
# time, and ours asks for all of them at once.
#
# Runs in the upstream checkout once the patches are applied. Only that exact
# pin is replaced. The fork commits change no manifest, so Cargo.lock keeps
# every version and only its whatsapp-rust sources move, and the --locked
# build that follows still holds. When upstream changes the pin this does
# nothing and says so: rebase the fork's zapfast-group-send branch onto the new
# pin, or remove this script once upstream has both changes.
set -euo pipefail

old_rev=719f29498124acaede51c555c8f1c7a1c423fb3d
new_rev=6c6d49481b55aaa7c9e9047d78f1c395b86538f7
old_dep="whatsapp-rust = { git = \"https://github.com/oxidezap/whatsapp-rust\", rev = \"$old_rev\""
new_dep="whatsapp-rust = { git = \"https://github.com/Goodly58/whatsapp-rust\", rev = \"$new_rev\""
old_source="git+https://github.com/oxidezap/whatsapp-rust?rev=$old_rev#$old_rev"
new_source="git+https://github.com/Goodly58/whatsapp-rust?rev=$new_rev#$new_rev"

if ! grep -qF "$old_dep" Cargo.toml; then
  echo "::notice title=whatsapp-rust pin changed::Upstream no longer pins whatsapp-rust at 719f294, so scripts/repin-whatsapp-rust.sh left it alone and large-group first sends are slow again. Rebase Goodly58/whatsapp-rust zapfast-group-send onto the new pin and update the script, or remove it once upstream asks for a group's members in one request."
  exit 0
fi

# Literal replacements by perl: the bash 3.2 macOS ships takes hours over
# ${lock//…} on a lockfile this size.
OLD=$old_dep NEW=$new_dep perl -pi.bak -e 's/\Q$ENV{OLD}\E/$ENV{NEW}/' Cargo.toml
OLD=$old_source NEW=$new_source perl -pi.bak -e 's/\Q$ENV{OLD}\E/$ENV{NEW}/g' Cargo.lock
rm -f Cargo.toml.bak Cargo.lock.bak

if grep -qF "$old_source" Cargo.lock || ! grep -qF "$new_source" Cargo.lock; then
  echo "::error title=whatsapp-rust pin::Cargo.lock still names the old whatsapp-rust source"
  exit 1
fi
echo "whatsapp-rust now at Goodly58/whatsapp-rust ${new_rev:0:7} (719f294 plus #2077 and one-request group checks)"
