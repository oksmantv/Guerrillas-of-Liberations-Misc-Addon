# OKS_GOL_Misc — Dynamic Radio Chat Overlay (`_ShowChatDynamic`)

## Files
- `functions/ambience/fn_Chat.sqf` — core function; `_ShowChatDynamic` is a private code block inside it that renders the on-screen animated radio message.
- `functions/ambience/fn_ChatGlobal.sqf` — 7-param `remoteExec` wrapper so any client can trigger a chat message globally.

## What it does
`OKS_fnc_Chat` shows a radio/side/local chat message either as:
- Static: vanilla `sideChat` (`_ShowStaticChat`)
- Dynamic: a custom animated on-screen box via `BIS_fnc_dynamicText` (`_ShowChatDynamic`) — icon + callsign header + wrapped message body, fading in/out, stacking with other recent messages.

Selection is controlled by `GOL_Player_IntelMessage_Setting` (0 = off, 1 = static, 2 = dynamic — default).

## Call signature
```sqf
["Battalion HQ","side","Message text here","Battalion HQ",sideUnknown,"\OKS_GOL_Misc\data\images\logo.paa",true] spawn OKS_fnc_ChatGlobal;
```
`[Talker, Channel("side"/"local"), Message, Callsign, TargetSide, IconPath, ShowNotification]`

## Architecture (current, working)
- **Single combined structured-text string, single `BIS_fnc_dynamicText` call.** The icon (`<img>`) is a sibling of the header `<t>` tag inside ONE string — not a separate control/layer. This was a major simplification from an earlier dual-layer (icon box + text box) design that caused most of the historical bugs (see "History" below).
- **Icon floats beside header text on the same line** — confirmed via debug-console testing that Structured Text does this natively; no manual layout math needed for that alignment. `valign='middle'` on both the `<img>` and the header `<t>` vertically centers the shorter text against the taller icon.
- **Icon/line height derived by ratio, not measurement.** `<t size='X'>` and `<img size='X'/>` share the same base font-size unit (`RscStructuredText` config's `size = GUI_TEXT_SIZE_MEDIUM`, see `functions/logic/baseControls.hpp` lines ~94-104, 882-903). Only the header line is measured directly (`ctrlTextHeight` on a scratch `RscStructuredText` control); icon height and per-line body height are both derived from that single measurement via simple ratio (`_headerHeight * (_iconSize/_headerSize)`, etc.). `ctrlTextHeight` does NOT reliably measure an `<img>`-only structured text, which is why the icon is never measured directly.
- **Box height is dynamic per-message**, based on: top row height (max of header/icon height) + `_lineCount * _lineHeight` + padding, clamped between `_minHeightFactor` and `_maxHeightFactor` (as fractions of `safeZoneH`).
- **`_lineCount` is a char-count estimate**, not a real wrap measurement: `ceil(count(trim(_Message)) / _charsPerLine)`. This is a deliberate approximation — real per-control wrap points aren't reliably queryable ahead of render, so an empirically-calibrated chars-per-line constant is used instead, with `ceil()` chosen to round UP (never underestimate/clip) rather than down.
- **3-slot stacking system**: `player getVariable "OKS_ChatSlotState"` stores `[[occupiedUntil, height], ...] x3`. New messages claim the first free slot (or wait for the soonest one), and `_stackOffset` sums the heights+gaps of slots still active above the claimed slot — so vertical stacking collapses naturally when an earlier message's phase finishes early, instead of using a fixed 3-row grid.
- **Layer rotation**: `player getVariable "OKS_ChatDynamicLayer"` rotates 935→946 per message so overlapping `dynamicText` calls don't reuse the same display layer while still fading.

## All tunable knobs (`missionNamespace setVariable`, live, no rebuild)
| Variable | Default | Meaning |
|---|---|---|
| `GOL_ChatXOffset` | 0.004 | safeZoneW factor — left margin |
| `GOL_ChatBoxWidth` | 0.245 | safeZoneW factor — message box width |
| `GOL_ChatHeaderSize` | 0.63 | `<t size>` for callsign line |
| `GOL_ChatBodySize` | 0.51 | `<t size>` for message body |
| `GOL_ChatIconSize` | 1.1 | `<img size>` — shares unit with header/body size |
| `GOL_ChatPadding` | 0.016 | safeZoneH factor — bottom padding under wrapped text |
| `GOL_ChatCharsPerLine` | 62 | estimated chars per wrapped line (see Calibration below) |
| `GOL_ChatMinHeight` | 0.075 | safeZoneH factor — floor for box height |
| `GOL_ChatMaxHeight` | 0.30 | safeZoneH factor — ceiling for box height (clipping risk above this on very long messages) |
| `GOL_ChatBaseY` | 0.445 | safeZoneH factor — vertical start of the message stack |
| `GOL_ChatSlotGap` | 0.014 | safeZoneH factor — gap between stacked messages |
| `GOL_ChatSlotHoldExtra` | 1.0 | seconds — extra time a slot stays reserved after fade-out |
| `GOL_ChatIconHeightMult` | 1.0 | safety multiplier on derived icon height |
| `GOL_ChatLineHeightMult` | 1.0 | safety multiplier on derived body line height |
| `GOL_ChatFadeIn` | 0.20 | seconds |
| `GOL_ChatFadeOut` | 1.25 | seconds |
| `GOL_ChatHoldExtra` | 1.4 | seconds — extra hold time added to display duration |

All knobs have type-guard fallbacks and `max/min` clamps, so a bad console value never breaks the function.

## `GOL_ChatCharsPerLine` calibration methodology
Real per-line wrap capacity was never directly measurable (Structured Text doesn't expose wrap points), so it's estimated from real in-game observation. Process used this session:
1. Get the user's exact test message texts (not guesses).
2. Count `count (trim _Message)` chars precisely for each.
3. Compute `ceil(charCount / candidateValue)` for a few candidate `_charsPerLine` values.
4. Cross-check against what actually rendered in-game (extra blank row under a message = overestimate of line count = `_charsPerLine` too LOW; text visually overflowing/clipping = `_charsPerLine` too HIGH).
5. Iterate toward the value that matches real wraps across a WIDE spread of message lengths (short/medium/long), not just one sample.

**Key lesson learned**: an observed "extra row of space" under a message means the estimate is too conservative (chars-per-line too low → line count overestimated), which is the OPPOSITE of what intuition suggests. Confirmed empirically: lowering the value from 54→48→45 did NOT fix an extra-row issue; raising it to 62 did. Current default `62` was validated across four separate test ranges: close-length messages, wide-spread lengths, near-boundary pairs, and an extreme (~377 char) stress test for the `_maxHeightFactor` clamp.

## Confirmed Structured Text facts (validated this session)
- Officially documented `<t>` attributes (BIS wiki): `size`, `color`, `font`, `align`, `valign`, `underline`, `shadow`, `shadowColor`, `shadowOffset`, `colorLink`, `href`. `<img>` supports: `image`, `size`, `align`, `valign`, `shadow`.
- **`bgcolor` is NOT a real attribute** on `<t>` or `<img>` — confirmed against the official wiki attribute list. It was present in this codebase for a long time (`bgcolor='#000000CC'`) and silently did nothing (no visual effect, likely also logged "Unknown attribute" warnings to the `.rpt`). It has been removed entirely.
- `color` format is `#RRGGBB` or `#AARRGGBB` (**alpha FIRST**, not last).
- Structured Text floats an `<img>` and adjacent wrapping `<t>` text on the same visual line automatically (no manual box math needed for that).
- Backslash-style Arma paths (`\OKS_GOL_Misc\data\images\logo.paa`) render fine directly in `<img>` — no forward-slash conversion needed.

## History / root-caused bugs (for context, all fixed)
1. **Use-before-declaration**: `_iconXLeft` referenced before declared — fixed by reordering.
2. **`ctrlCommit` ordering bug (major)**: the scratch measurement control called `ctrlCommit 0` BEFORE `ctrlSetStructuredText`, so `ctrlTextHeight` measured stale empty text (`text=""`), returning ~0. This silently zeroed `_lineHeight`, `_iconHeight`, and `_controlHeight` — explaining simultaneously why the icon was invisible AND why box height never scaled with message length. Fixed by moving `ctrlCommit 0` to AFTER `ctrlSetStructuredText`, plus a safety floor `(ctrlTextHeight _measureCtrl) max (safeZoneH * 0.025)`.
3. **Compounding multiplier bug**: independent multipliers (`iconSize` ratio × `iconHeightMult`) compounded to ~8.7x, making the icon "massive". Always sanity-check combined effects of stacked multipliers.
4. **Dual-layer icon system → collapsed to single call**: originally the icon was a separate `dynamicText` layer synced to the text layer (separate position, separate layer rotation, row-height reconciliation). This was the root cause of most alignment/visibility bugs. Replaced entirely once it was confirmed Structured Text can float an image beside text in one string.
5. **`bgcolor` dead code**: see above — never a real attribute, removed.

## Next stage: background panel (Tier 2 — not yet implemented)
**Goal**: light-gray, soft-edged, semi-transparent background behind each message box, similar in spirit to vanilla `systemChat`.

**Why Tier 1 (markup-only) is impossible**: Structured Text has no `bgcolor`/background attribute at all (see above). A visible panel MUST come from an actual second UI control, not `<t>`/`<img>` markup.

**Planned approach**:
1. Create a second control (e.g. `ctrlCreate ["RscText", -1]` or a minimal custom class) positioned at the exact same rectangle already computed for the text: `[_xLeft, _targetYPos, _xWidth, _controlHeight]`.
2. Set its fill via `ctrlSetBackgroundColor` (light gray, low alpha — e.g. `[0.78,0.78,0.78,0.4]`) for a flat rectangle (easy, low risk since it's just one static rect, no wrapping/flow interaction to keep in sync).
3. Sync its lifetime to the SAME `_fadeIn` / `_phaseDuration` / `_fadeOut` timing already computed for the text call — spawn it just before the `dynamicText` call, fade it in, hold, fade it out, then `ctrlDelete` it, all inside a small parallel `spawn` scoped to the same `_ShowChatDynamic` call.
4. Must NOT reuse the `935-946` layer rotation used for text (that's `dynamicText`'s internal layer bookkeeping) — needs its own control reference held directly by our script (we get a real `ctrl` handle this time, unlike `dynamicText` which manages its own control internally and gives us no handle back).
5. **Optional soft/feathered edge** (matching `systemChat` exactly): requires a custom texture asset (`.paa` with a baked alpha-feathered border) drawn via `RscPicture` instead of a flat `ctrlSetBackgroundColor` rectangle — meaningfully more work (asset creation + stretching it to a dynamic per-message height/width) and should only be pursued after confirming the flat version looks acceptable.
6. Expose the same live-tunable knob pattern used everywhere else in this function: `GOL_ChatBgEnabled`, `GOL_ChatBgColor` (as an `[r,g,b,a]` array this time, not a hex string, since `ctrlSetBackgroundColor` takes an RGBA array), etc.

**Risk to watch**: this reintroduces a second control that must stay positionally/temporally in sync with the text — the exact category of bug (icon/text desync) that took two days to eliminate in the single-layer refactor. Keep the background control's logic as simple as possible (one static rect, same rectangle/timing as already-computed values, no independent flow/wrap logic) to avoid repeating that history.
