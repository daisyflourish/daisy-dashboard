#!/bin/bash
# Usage: log-task.sh "task name" "status" "model" tokens_in tokens_out "brand" [start] [end]
# Appends to time-log.json

LOG="/tmp/daisy-dashboard/time-log.json"
TASK="${1:-Unknown}"
STATUS="${2:-completed}"
MODEL="${3:-claude-opus-4-6}"
TOKENS_IN="${4:-0}"
TOKENS_OUT="${5:-0}"
BRAND="${6:-system}"
START="${7:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}"
END="${8:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}"

# Ensure file exists with valid JSON array
[ ! -f "$LOG" ] && echo '[]' > "$LOG"
[ ! -s "$LOG" ] && echo '[]' > "$LOG"

# Append entry using python (available on macOS)
python3 -c "
import json, sys
with open('$LOG') as f:
    data = json.load(f)
data.append({
    'task': '''$TASK''',
    'status': '$STATUS',
    'model': '$MODEL',
    'tokens_in': $TOKENS_IN,
    'tokens_out': $TOKENS_OUT,
    'brand': '$BRAND',
    'start': '$START',
    'end': '$END'
})
with open('$LOG', 'w') as f:
    json.dump(data, f, indent=2)
"
echo "Logged: $TASK ($STATUS)"
