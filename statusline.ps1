# ═══════════════════════════════════════════════════
# cc-statusline - A minimal, beautiful statusline for Claude Code (Windows)
# ═══════════════════════════════════════════════════

# --- User Config (edit these) ---
$BAR_LENGTH        = 20        # Progress bar width (chars)
$WARN_THRESHOLD    = 70        # Yellow warning at this %
$CRIT_THRESHOLD    = 90        # Red critical at this %

# --- Read JSON from stdin ---
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$raw = [System.Console]::OpenStandardInput()
$bytes = [byte[]]::new(8192)
$n = $raw.Read($bytes, 0, $bytes.Length)
$jsonStr = [System.Text.Encoding]::UTF8.GetString($bytes, 0, $n)
$input_json = $jsonStr | ConvertFrom-Json

# --- Extract fields ---
$dir      = if ($input_json.workspace.current_dir) { Split-Path $input_json.workspace.current_dir -Leaf } else { "?" }
$branch   = if ($input_json.workspace.git_branch) { $input_json.workspace.git_branch } else { "" }
$model    = if ($input_json.model.display_name) { $input_json.model.display_name } else { "?" }
$ctxPct   = $input_json.context_window.used_percentage
$thinking = if ($input_json.thinking.enabled) { $input_json.thinking.enabled } else { $false }

if (-not $ctxPct) { $ctxPct = 0 }
$ctxPct = [math]::Floor([double]$ctxPct)

# --- ANSI escape (PS 5.1 compatible via [char]27) ---
$esc = [char]27

$reset  = "${esc}[0m"
$dim    = "${esc}[2m"
$bold   = "${esc}[1m"
$cyan   = "${esc}[38;5;81m"
$purple = "${esc}[38;5;176m"
$gray   = "${esc}[38;5;252m"

# --- Unicode block chars (PS 5.1 safe via [char]) ---
$blockFull  = [char]0x2588  # █
$blockLight = [char]0x2591  # ░

# --- Progress bar ---
$filled = [math]::Round($ctxPct / 100 * $BAR_LENGTH)
$empty  = $BAR_LENGTH - $filled

if ($ctxPct -ge $CRIT_THRESHOLD) {
    $barColor = "${esc}[38;5;203m"       # Red
    $pctColor = "${esc}[38;5;203;1m"
} elseif ($ctxPct -ge $WARN_THRESHOLD) {
    $barColor = "${esc}[38;5;220m"       # Yellow
    $pctColor = "${esc}[38;5;220;1m"
} else {
    $barColor = "${esc}[38;5;78m"        # Green
    $pctColor = "${esc}[38;5;78;1m"
}

$bar  = "$barColor"
$bar += [string]$blockFull * $filled
$bar += "${dim}${blockLight}"
$bar += [string]$blockLight * [math]::Max(0, $empty - 1)
$bar += "${reset}"

# --- Git branch ---
$gitInfo = if ($branch) { "$dim($branch)$reset " } else { "" }

# --- Thinking status ---
if ($thinking) {
    $thinkStr = "${esc}[38;5;117;1m ON"
} else {
    $thinkStr = "${gray} OFF"
}

# --- Output ---
$sep = "$dim|$reset"
Write-Host " ${bold}${cyan} $dir $reset$gitInfo$sep ${purple}$model $reset$sep $bar $pctColor$ctxPct%$reset$sep think:${thinkStr}${reset}"
