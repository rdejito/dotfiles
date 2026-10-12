#!/bin/bash
# Rofi calendar popup for the Polybar date/time modules.

set -u

THEME="$HOME/.config/rofi/calendar.rasi"
OFFSET="${1:-0}"

# Build the month view (rendered in rofi's message box).
read -r -d '' PY <<'PY'
import sys, calendar, datetime

offset = int(sys.argv[1])
today = datetime.date.today()

year = today.year
month = today.month + offset
year += (month - 1) // 12
month = (month - 1) % 12 + 1

NBSP = "\u00a0"
title = f"{calendar.month_name[month]} {year}"
lines = [title.center(20).replace(" ", NBSP)]
lines.append("Mo Tu We Th Fr Sa Su".replace(" ", NBSP))

for week in calendar.monthcalendar(year, month):
    cells = []
    for day in week:
        if day == 0:
            cells.append(NBSP * 2)
        elif (year, month, day) == (today.year, today.month, today.day):
            num = f"{day:2d}".replace(" ", NBSP)
            cells.append(
                "<span foreground='#ff1744' background='#880808' "
                f"weight='bold'>{num}</span>"
            )
        else:
            cells.append(f"{day:2d}".replace(" ", NBSP))
    lines.append(NBSP.join(cells))

print("\n".join(lines))
PY

MESG=$(python3 -c "$PY" "$OFFSET")

declare -a LABELS=()
declare -a ACTIONS=()

add_line() {
    LABELS+=("$1")
    ACTIONS+=("$2")
}

add_line "󰁍  Prev" "prev"
add_line "󰃭  Today" "today"
add_line "󰁔  Next" "next"

CHOICE=$(printf '%s\n' "${LABELS[@]}" |
    rofi -dmenu -markup -mesg "$MESG" -theme "$THEME")
[ -z "$CHOICE" ] && exit 0

ACTION=""
for i in "${!LABELS[@]}"; do
    if [ "${LABELS[$i]}" = "$CHOICE" ]; then
        ACTION="${ACTIONS[$i]}"
        break
    fi
done
[ -z "$ACTION" ] && exit 0

case "$ACTION" in
    prev)
        exec "$0" "$((OFFSET - 1))"
        ;;
    next)
        exec "$0" "$((OFFSET + 1))"
        ;;
    today)
        [ "$OFFSET" -eq 0 ] && exit 0
        exec "$0" 0
        ;;
esac
