#!/usr/bin/env bash

# macOS system info for the tmux status bar (consumed by custom-minimal-theme.sh)

get_cpu_usage() {
    # Sum per-process recent CPU and normalize by core count — instant,
    # unlike `top -l 2` which blocks a full second per sample.
    ps -A -o %cpu | awk -v cores="$(sysctl -n hw.ncpu)" '{s+=$1} END {printf "%.0f", s/cores}'
}

get_time() {
    date "+%H:%M"
}

case "$1" in
    cpu)
        get_cpu_usage
        ;;
    time)
        get_time
        ;;
    *)
        echo "Usage: $0 {cpu|time}"
        exit 1
        ;;
esac
