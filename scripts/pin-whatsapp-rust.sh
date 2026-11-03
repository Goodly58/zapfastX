#!/usr/bin/env bash
# Moves whatsapp-rust to upstream's fix for an offline backlog that never
# drains (oxidezap/whatsapp-rust#1813). After a long sleep a busy chat's
# backlog overflows its 64-item lane, the connection recycles and the server
# redelivers the same batch, so ZapFast says it is not connected and refuses
# to send. #1814 widens the lane to 512 and #1823 fixes what it left behind.
# ZapFast 0.20.1 to 0.21.0 pin crmne's fork at 94f7c13, from before the fix;
# its two commits there are upstream as #1789 and #1790.
#
# Runs in the upstream checkout once the toolchain is set up. Only that exact
# pin is replaced, so when upstream moves on this does nothing and can go.
# Cargo.lock is then re-resolved for the changed dependency alone, and the
# --locked build that follows still holds every other version.
set -euo pipefail

old='whatsapp-rust = { git = "https://github.com/crmne/whatsapp-rust", rev = "94f7c1376f8f6a77c55d85570a260600ad27de0b"'
new='whatsapp-rust = { git = "https://github.com/oxidezap/whatsapp-rust", rev = "31626c4f197d04232735e2e773caf48f85e81f14"'

if ! grep -qF "$old" Cargo.toml; then
  echo "::notice title=whatsapp-rust pin changed::Upstream no longer pins whatsapp-rust at 94f7c13; scripts/pin-whatsapp-rust.sh did nothing and can be removed once upstream has oxidezap/whatsapp-rust#1814"
  exit 0
fi

manifest=$(<Cargo.toml)
printf '%s\n' "${manifest/"$old"/"$new"}" > Cargo.toml
cargo metadata --format-version 1 > /dev/null
grep -q 'oxidezap/whatsapp-rust?rev=31626c4f197d04232735e2e773caf48f85e81f14' Cargo.lock
echo "whatsapp-rust now at oxidezap/whatsapp-rust 31626c4"
