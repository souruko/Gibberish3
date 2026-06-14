# Gibberish3 – Settings Reference

## Structure

Everything in Gibberish3 is organised in a four-level hierarchy:

```
Folder
  └── Window          (a visible display panel on screen)
        └── Timer     (one bar, icon, circle, or counter inside the window)
              └── Trigger   (what starts, stops, or modifies the timer)
```

You create windows and timers in the options panel, then assign triggers to each timer that tell it when to run. A window holds one or more timers of the same visual type.

---

## Window Settings

### General tab

| Setting | What it does |
|---|---|
| **Description** | Internal label shown in the window list. Has no effect on display. |
| **Save Globally** | When checked, the window **position** is shared across all your characters. When unchecked, each character saves its own position. All other settings are always global. |
| **Reset on Target Change** | Clears all running timers in this window whenever you select a different target. Useful for debuff tracking where old timers should not carry over. |
| **Use Target Entity** | Attaches the current target's identity to each timer when it starts. Required for **Per Target** stacking to work correctly. Only effective with effect triggers (EffectSelf, EffectGroup). |
| **Overlay** | When checked, the window renders on top of the LOTRO interface (HUD elements will not obscure it). When unchecked the game UI can cover the window. |
| **Timer Type** | Which visual style the timers in this window use: Bar, Icon, Circle, Text, or Counter Bar. Counter Windows only support Counter Bar. |

### Size tab

| Setting | What it does |
|---|---|
| **Width / Height** | Size of each individual timer element, in pixels. |
| **Frame** | Thickness of the border around each timer, in pixels. Set to 0 to remove the border. |
| **Spacing** | Gap between timers when multiple are displayed at once, in pixels. |
| **Orientation** | Whether timers stack **Vertically** (top to bottom) or **Horizontally** (left to right). |
| **Direction** | Which way the window grows when new timers are added: **Ascending** (downward/rightward) or **Descending** (upward/leftward). |
| **Sort Direction** | How timers are ordered by remaining time: **Ascending** (shortest first) or **Descending** (longest first). |

### Color tab

| Color slot | Used for |
|---|---|
| **Frame Color** | Border around each timer. |
| **Back Color** | Background fill behind the timer bar/icon. |
| **Bar Color** | The progress bar itself (BAR and COUNTER_BAR types). |
| **Timer Color** | Font color for the countdown number. |
| **Text Color** | Font color for the label/name text. |
| **Outline Color** | Outline drawn around both the timer number and text. |
| **Threshold Back Color** | Background color that replaces Back Color once the threshold is active. |
| **Threshold Timer Color** | Replaces Timer Color once the threshold is active. |
| **Threshold Text Color** | Replaces Text Color once the threshold is active. |

| Opacity setting | When it applies |
|---|---|
| **Opacity Active** | While the timer is running. |
| **Opacity Passive** | While no timer is running (only visible when Display Permanently is on). |
| **Opacity Threshold** | While the timer is running and within the threshold zone. |

### Text tab

| Setting | What it does |
|---|---|
| **Font** | Typeface used for all text in this window. |
| **Font Size** | Size of the font in points. |
| **Number Format** | How the countdown is displayed: **Seconds** (`7`), **Minutes** (`0:07`), **One Decimal** (`7.4`). |
| **Text Alignment** | Where the label/name text sits within the timer element. |
| **Timer Alignment** | Where the countdown number sits within the timer element. |
| **Display Timer** | When unchecked, the countdown number is hidden entirely. |
| **Threshold Font / Threshold Font Size** | Font overrides that apply while inside the threshold zone. Lets you make the number larger or bolder as the timer runs low. |

---

## Timer Settings

Each timer has its own tabs. Some tabs only appear for certain timer types.

### General tab

| Setting | What it does |
|---|---|
| **Description** | Internal label shown in the timer list. |
| **Display Permanently** | When checked, the timer stays visible even while inactive (shows at zero or passive state). Without this, the timer appears only while running. |
| **Stacking** | How the plugin handles multiple simultaneous triggers for this timer (see below). |
| **Loop** | When the timer reaches zero it immediately restarts instead of ending. Stop it with a Reset action. |
| **Reset** | When checked, the timer can be stopped and reset to zero by a **Reset** action. When unchecked, Reset actions have no effect on this timer. |
| **Protect** | When checked, the timer ignores any new **Add** triggers while it is already running. Useful when an effect refreshes with a shorter remaining time than expected, and you want the timer to complete its full duration undisturbed. |
| **Use Custom Timer** | When checked, ignores the duration reported by the game and runs for the fixed **Timer Value** instead. Useful for effects that report the wrong duration, or for triggers that carry no duration (combat events, skills). |
| **Timer Value** | The fixed duration in seconds, used only when Use Custom Timer is enabled. |

#### Stacking options

| Option | Behaviour |
|---|---|
| **Single** | Only one instance of this timer runs at a time. A new trigger replaces the running timer. Default for Circle and Counter Bar. |
| **Allow Multiple** | Multiple instances can run simultaneously. Each trigger adds a new row. Default for Bar, Icon, and Text. |
| **Per Target** | One instance per target entity. Requires **Use Target Entity** to be enabled on the window. Each target gets its own timer; switching targets shows only the timer for the current target. |

### Style tab (Bar, Icon, Circle, Text)

| Setting | What it does |
|---|---|
| **Icon** | The icon displayed on the timer. If left at the default blank/placeholder value, the icon from the triggering game effect is used automatically. Enter a numeric icon ID to override it. |
| **Display Icon** | Toggle whether the icon is shown at all. |
| **Direction** | Whether the timer counts **Descending** (down from full to zero) or **Ascending** (up from zero). |
| **Text Option** | What text label to show alongside the timer (see below). |
| **Text** | The literal string displayed when Text Option is set to Custom Text. Supports markup and placeholders (see Placeholders section). |
| **Use Shadow** *(Icon only)* | Adds a clockwise sweep overlay on the icon showing elapsed time — similar to a cooldown spiral in other games. |

#### Text options

| Option | What is displayed |
|---|---|
| **No Text** | Nothing. |
| **Token** | The capture group `&1` from the regex match, or the effect name for effect triggers. |
| **Custom Text** | The fixed string you enter in the Text field. |
| **Target Name** | The name of your current target at the moment the timer started. |

### Style tab (Counter Bar)

| Setting | What it does |
|---|---|
| **Counter Start** | The value the counter begins at when first triggered. |
| **Counter End** | The value at which the counter stops ticking. |
| **Direction** | **Descending** counts down from Start to End; **Ascending** counts up from Start to End. |

### Animation tab

Animations trigger when the timer enters the threshold zone.

| Setting | What it does |
|---|---|
| **Use Threshold** | Enables threshold mode. When the remaining time (or counter value) crosses the threshold, colors and font change to the threshold overrides, and the animation starts. |
| **Threshold Value** | The time in seconds (or count value) at which the threshold activates. For descending timers this fires when time remaining falls below this value. |
| **Use Animation** | Whether to play the animation when the threshold is active. Colors still change even when animation is off. |
| **Animation Type** | Visual style of the animation (see below). |
| **Animation Speed** | How fast the animation cycles. Higher is faster. |

#### Animation types

| Type | Description |
|---|---|
| **Flashing** | The timer element flashes on and off. |
| **Zoom** *(Icon only)* | The icon pulses larger and smaller. |
| **New Activation Border** | An animated glowing border appears around the icon. |
| **New Dotted Border** | An animated dotted border appears around the icon. |
| **Old Activation Border** | Legacy activation border style. |
| **Old Dotted Border** | Legacy dotted border style. |

### Trigger tab

Lists triggers assigned to this timer. Each trigger has its own row with a **Token**, **Action**, and type-specific options. See the Triggers section below.

---

## Triggers

Triggers tell a timer what to do and when. Each timer can have multiple triggers. You assign them on the **Trigger tab** of the timer.

### Common trigger fields

| Field | What it does |
|---|---|
| **Description** | Internal label. No effect on behaviour. |
| **Action** | What the trigger does to the timer when it fires (see Actions below). |
| **Value** | Numeric argument used by some actions (e.g. the number to add or subtract for counter triggers). |

### Actions

| Action | Effect on the timer |
|---|---|
| **Add** | Starts the timer. If it is already running and stacking is Single, resets it. If Allow Multiple, creates a new instance. |
| **Remove** | Stops and removes the timer (or the matching stacked instance). |
| **Reset** | Stops the timer and returns it to zero. Only works when the timer's own **Reset** setting is enabled. |
| **Enable** | Enables the timer (reverses a Disable). |
| **Disable** | Disables the timer so future triggers are ignored. |
| **Subtract** *(Counter only)* | Subtracts Value from the current counter. |
| **Clear** *(Counter only)* | Resets the counter to its Counter Start value and removes all instances. |
| **Set To** *(Counter only)* | Sets the counter to an exact value. |

### Trigger types

#### Chat trigger

Fires when a specific message appears in chat.

| Field | What it does |
|---|---|
| **Token** | The text pattern to match against the chat message. |
| **Use Regex** | When checked (default), the token is a Lua pattern (`%d+`, `.+`, etc.). Capture groups `()` are accessible as `&1`, `&2` in text labels. When unchecked, matches the literal string. |
| **Chat Channel** | If set to something other than Any, only messages from that channel are checked. |
| **List of Targets** | If filled, the trigger only fires when the message also contains one of the listed names. Separate multiple names with `;`. |

#### Combat trigger

Fires on a combat state change.

| Field | What it does |
|---|---|
| **Token** | Optionally filter by combat log message content. Leave blank to fire on any combat start/end. |
| **Combat Event** | **Start** = fires when you enter combat. **End** = fires when you leave combat. |

#### Effect Self trigger / Effect Remove Self trigger

Fires when a buff or debuff is **applied to you** (Self) or **removed from you** (Remove Self).

| Field | What it does |
|---|---|
| **Token** | The effect name to match. Leave blank to match any effect. |
| **Use Regex** | Enables Lua pattern matching on the effect name. |
| **Icon** | If set, additionally requires the effect's icon to match. Leave blank to ignore. |
| **Type** | Filter by Buff or Debuff. Leave blank for any. |
| **Cureable** | Filter by whether the effect can be dispelled. |
| **Category** | Filter by effect category (Corruption, Disease, Fear, Poison, Wound, etc.). Leave blank for any. |

#### Effect Group trigger

Same as Effect Self but watches effects applied to **any member of your fellowship or raid**. Has one extra field:

| Field | What it does |
|---|---|
| **Exclude Self** | When checked, effects on yourself are ignored — only fellowship/raid members trigger it. Useful for tracking group debuffs without also tracking your own. |

#### Skill trigger

Fires when you use a skill.

| Field | What it does |
|---|---|
| **Token** | The exact skill name to watch for. The skill list is populated from your current trait configuration. If you change traits, use **Auto Reload** to refresh the list. |
| **Use Regex** | Enables pattern matching on the skill name. |

> **Note:** The skill list is read when the plugin loads. After changing trait lines or acquiring new skills, use the **Auto Reload** shortcut button to pick up the changes without a full game restart.

#### Timer Start / Timer End / Timer Threshold triggers

Fire when another timer in the plugin starts, ends, or crosses its threshold. This lets you chain timers together.

| Field | What it does |
|---|---|
| **Token** | The **Description** of the source timer to watch. Must match exactly (or by regex if Use Regex is on). |

---

## Placeholders

Placeholders can be used in the **Custom Text** field of a timer or in **Chat trigger tokens**.

| Placeholder | Replaced with |
|---|---|
| `&1`, `&2`, … | The corresponding regex capture group from the matching chat message. |
| `&name` | Your character's name. |
| `&class` | Your character's class. |
| `&target` | The name of your current target at the time the timer started. |

Example: if your chat token is `(%w+) hits you` and Text Option is set to Token, `&1` in Custom Text will display the name of whoever hit you.

---

## The Collection

The Collection is a helper tool for setting up triggers. Instead of guessing effect names or chat patterns, you record them live:

- **Collect Effects** — captures all effects currently on you or the group and lists them with their exact name, icon, and timer. Click any entry to copy its token and icon directly into a new trigger.
- **Collect Chat Messages** — captures chat messages as they arrive. Options let you filter to debuffs only or the Say channel only.

Use the Collection to find the exact spelling of an effect name before writing a trigger for it.

---

## Import / Export

Windows, timers, triggers, and folders can all be exported as a text string and imported by another player or across characters.

- **Export** — right-click a folder or window in the selection panel and choose Export → what to export. The string appears in a box; it is automatically selected for copying.
- **Import** — click the Import button (bottom of the selection panel). Paste the string and choose whether to **Create New** (adds to the window list) or **Insert into Selection** (merges into the currently selected window or folder).

Community-shared configs are available at **https://lotro-gibberish.com/**

---

## Shortcut Button

The small Gibberish shortcut button on your toolbar opens a quick menu:

| Option | What it does |
|---|---|
| **Open Options** | Opens the main options panel. |
| **Move Windows** | Toggles the move handles that let you drag windows around the screen. |
| **Reset All** | Stops all running timers and resets all counters. |
| **Track Group** | Switches effect tracking to your fellowship/raid. |
| **Track Target** | Switches effect tracking to your current target. |
| **Auto Reload** | Reloads the plugin. Use this after changing trait lines to update the skill trigger list. |
| **Reload Plugin** | Full plugin reload. |
