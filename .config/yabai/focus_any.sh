#!/usr/bin/env bash

set -u

dir="${1:-}"

case "$dir" in
  north|south|east|west) ;;
  *)
    exit 2
    ;;
esac

if yabai -m window --focus "$dir" >/dev/null 2>&1; then
  exit 0
fi

case "$dir" in
  east|south)
    if yabai -m window --focus stack.next >/dev/null 2>&1; then
      exit 0
    fi
    ;;
  west|north)
    if yabai -m window --focus stack.prev >/dev/null 2>&1; then
      exit 0
    fi
    ;;
esac

exit 1
