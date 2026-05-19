# cc-statusline

A minimal, beautiful statusline for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) on Windows.

Zero dependencies. One file. Copy and go.

## What it looks like

<img width="847" height="79" alt="cc-statusline screenshot" src="screenshot.png" />

- **Directory** + git branch — know where you are
- **Model name** — always visible
- **Context bar** — colored `█░` progress bar, changes color as context fills up:
  - Green (< 70%)
  - Yellow (70–90%)
  - Red (> 90%)
- **Thinking mode** — ON/OFF at a glance

## Install

### 1. Download

Download `statusline.ps1` to any location, e.g.:

```
C:\Users\YourName\.claude\statusline.ps1
```

### 2. Configure

Open your Claude Code settings file:

```
C:\Users\YourName\.claude\settings.json
```

Add the `statusLine` block:

```json
{
  "statusLine": {
    "type": "command",
    "command": "powershell -NoProfile -File C:/Users/YourName/.claude/statusline.ps1",
    "padding": 2
  }
}
```

> Adjust the path to where you saved `statusline.ps1`.

### 3. Restart Claude Code

That's it. The statusline will appear at the bottom of your terminal.

## Customize

Open `statusline.ps1` and edit the config block at the top:

```powershell
$BAR_LENGTH        = 20        # Progress bar width (chars)
$WARN_THRESHOLD    = 70        # Yellow warning at this %
$CRIT_THRESHOLD    = 90        # Red critical at this %
```

## Why this exists

Claude Code's default statusline is plain text. This gives you a compact, color-coded, single-line view with all the info you need at a glance.

- **PS 5.1 compatible** — uses `[char]27` and `[char]0x2588` to avoid encoding issues on Windows
- **Zero dependencies** — no Node.js, no npm, just PowerShell
- **Single file** — drop it anywhere, point settings.json to it, done

## License

MIT
