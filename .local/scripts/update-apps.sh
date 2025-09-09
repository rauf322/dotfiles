#!/bin/bash

# App Updater Script for Cursor and VS Code
# Runs daily via launchd to check for updates

LOG_FILE="$HOME/.local/scripts/logs/app-updates.log"

echo "$(date): Starting daily app update check" >> "$LOG_FILE"

# Update Homebrew first
echo "$(date): Updating Homebrew..." >> "$LOG_FILE"
/opt/homebrew/bin/brew update >> "$LOG_FILE" 2>&1

# Upgrade Cursor
echo "$(date): Checking for Cursor updates..." >> "$LOG_FILE"
/opt/homebrew/bin/brew upgrade --cask cursor >> "$LOG_FILE" 2>&1

# Upgrade VS Code
echo "$(date): Checking for VS Code updates..." >> "$LOG_FILE"
/opt/homebrew/bin/brew upgrade --cask visual-studio-code >> "$LOG_FILE" 2>&1

echo "$(date): Update check completed" >> "$LOG_FILE"
echo "---" >> "$LOG_FILE"