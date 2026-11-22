# ZapFastX

[ZapFast](https://github.com/crmne/zapfast) for Windows and macOS with a few patches on top. This isn't a separate app: every new ZapFast release is picked up, patched and published here automatically, so you get all of upstream's updates. Differences from upstream:

- **Read ticks always show**, even with your account's read receipts off.
- **Deleted messages stay.** Messages others delete for everyone are kept and marked *deleted*. Photos and voice notes download as they arrive, so deleted ones are kept too.
- **Edits keep their history.** Hover *edited* on someone's message to see what it said before.
- **Screen privacy.** Covers chats, messages, media, names and avatars until hovered (Ctrl+Shift+H, off by default). By [paulo1403](https://github.com/paulo1403) ([crmne/zapfast#451](https://github.com/crmne/zapfast/pull/451)), via [ZapFaster](https://github.com/eternalwaitt/zap-faster).
- **Ghost mode.** Never shows you as online (Settings → Privacy, off by default).
- **Scheduled messages.** Right-click Send to send text, photos or files later, up to a week ahead. Waiting messages sit above the composer until they go.
- **Updates come from this repository**, so they keep these changes.

<p align="center">
  <img src="docs/ticks.png" width="49%" alt="Read ticks turn blue even with read receipts off">
  <img src="docs/deleted.png" width="49%" alt="A message deleted for everyone stays, marked deleted">
</p>
<p align="center">
  <img src="docs/edits.png" width="49%" alt="Hovering edited shows what the message said before">
  <img src="docs/privacy.png" width="49%" alt="Screen privacy covers the chat list until you hover a row">
</p>
<p align="center">
  <img src="docs/ghost.png" width="49%" alt="With ghost mode on, others see your last seen instead of online">
  <img src="docs/scheduled.png" width="49%" alt="Right-click Send to schedule a message for later">
</p>
<p align="center">
  <img src="docs/updates.png" width="49%" alt="Each upstream release is patched and offered as an update">
</p>

**Also:** optional clean-up of media downloaded more than 3 months ago (Settings → Files, off by default). Media from deleted messages is always kept, by Clear too.

Everything else is upstream ZapFast. The changes are in [`patches/`](patches).

**[Download the latest release](https://github.com/Goodly58/zapfastX/releases/latest)**: `.msi` for Windows (x64 or ARM64), `.dmg` for Mac. The Mac app is unsigned, so open it the first time from System Settings → Privacy & Security → **Open Anyway**.

Unofficial build, not affiliated with ZapFast, WhatsApp or Meta. ZapFast © Carmine Paolino and contributors, [MIT](LICENSE).
