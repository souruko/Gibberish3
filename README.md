# Gibberish

Gibberish is a Lord of the Rings Online plugin for tracking cooldowns, effects, and counters as customisable HUD overlays. Set up timers that respond to game events — effects applied to yourself, your group, or your target; skills used; chat messages; combat state; or other timers starting/ending — and display them as bars, icons, circles, text labels, or counters. Timers can be gated behind conditions so they only appear when the right circumstances are met. Everything is configured through a built-in options panel without leaving the game.

## Features

- **Timer displays** — Bar, Icon, Circle, Text, or Counter Bar, each with its own style, color, and animation settings
- **Triggers** — effect applied/removed (self, group, or target), skill used, chat message, combat start/end, or another timer starting/ending/crossing its threshold
- **Conditions** — gate a timer behind one or more prerequisites that must all be active before it will display
- **Folders** — group related windows together and enable/disable them as a unit
- **Collection tool** — record live effects and chat messages so you can copy the exact name/pattern into a trigger instead of guessing
- **Import/Export** — share windows, timers, triggers, and folders as a text string with other players or across your own characters
- **Localised** — English, German, and French, detected automatically from your client

## Installation

1. Copy the `Gibberish3` folder into:
   `...\Documents\The Lord of the Rings Online\plugins\`
   so the final path is `...\plugins\Gibberish3\`
2. In-game, enable it from the plugin manager, or type `/plugins load Gibberish3` in chat.
3. To pick up an update without restarting the client, use `/plugins reload Gibberish3`.

## Getting Started

Open the settings panel from the Gibberish shortcut button on your toolbar, then build the hierarchy: create a **Folder** (optional), add a **Window**, add a **Timer** to it, and give the timer one or more **Triggers** that tell it when to start, stop, or update.

See [Usage.md](Usage.md) for a full reference of every setting, trigger type, and placeholder.

## Community Configs

Pre-built windows and timers shared by other players are available at **https://lotro-gibberish.com/** (by mydnic).

## Changelog

See [CHANGELOG.md](CHANGELOG.md).
