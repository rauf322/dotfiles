#!/usr/bin/env bash

# macOS-compatible system info script for tmux status bar

get_cpu_usage() {
    # Sum per-process recent CPU and normalize by core count — instant,
    # unlike `top -l 2` which blocks a full second per sample.
    ps -A -o %cpu | awk -v cores="$(sysctl -n hw.ncpu)" '{s+=$1} END {printf "%.0f", s/cores}'
}

get_memory_usage() {
    # Get memory usage on macOS
    vm_stat | awk '
    /^Pages free/ { free = $3 * 4096 }
    /^Pages active/ { active = $3 * 4096 }
    /^Pages inactive/ { inactive = $3 * 4096 }
    /^Pages speculative/ { speculative = $3 * 4096 }
    /^Pages wired/ { wired = $3 * 4096 }
    END {
        used = active + inactive + wired
        total = used + free + speculative
        printf "%.0f", (used / total) * 100
    }'
}

get_battery() {
    # Get battery percentage on macOS
    pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1
}

get_date() {
    date "+%d"
}

get_time() {
    date "+%H:%M"
}

case "$1" in
    cpu)
        get_cpu_usage
        ;;
    memory)
        get_memory_usage
        ;;
    battery)
        get_battery
        ;;
    date)
        get_date
        ;;
    time)
        get_time
        ;;
    *)
        echo "Usage: $0 {cpu|memory|battery|date|time}"
        exit 1
        ;;
esac