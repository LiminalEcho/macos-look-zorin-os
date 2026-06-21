#!/bin/bash

# ============================================
# Zorin OS Monthly Maintenance Script
# ============================================

LOGFILE="$HOME/.maintenance-log.txt"
DATE=$(date '+%Y-%m-%d %H:%M')

echo "========================================" | tee -a "$LOGFILE"
echo " Zorin OS Maintenance - $DATE" | tee -a "$LOGFILE"
echo "========================================" | tee -a "$LOGFILE"

echo "" | tee -a "$LOGFILE"
echo "[1/6] Updating system packages..." | tee -a "$LOGFILE"
sudo apt update && sudo apt upgrade -y | tee -a "$LOGFILE"

echo "" | tee -a "$LOGFILE"
echo "[2/6] Updating firmware..." | tee -a "$LOGFILE"
sudo fwupdmgr refresh | tee -a "$LOGFILE"
sudo fwupdmgr update | tee -a "$LOGFILE"

echo "" | tee -a "$LOGFILE"
echo "[3/6] Removing unused packages..." | tee -a "$LOGFILE"
sudo apt autoremove -y | tee -a "$LOGFILE"
sudo apt clean | tee -a "$LOGFILE"

echo "" | tee -a "$LOGFILE"
echo "[4/6] Clearing old logs (older than 7 days)..." | tee -a "$LOGFILE"
sudo journalctl --vacuum-time=7d | tee -a "$LOGFILE"

echo "" | tee -a "$LOGFILE"
echo "[5/6] Emptying trash..." | tee -a "$LOGFILE"
rm -rf ~/.local/share/Trash/*
echo "Trash emptied." | tee -a "$LOGFILE"

echo "" | tee -a "$LOGFILE"
echo "[6/6] Creating Timeshift snapshot..." | tee -a "$LOGFILE"
sudo timeshift --create --comments "Monthly maintenance - $DATE" | tee -a "$LOGFILE"

echo "" | tee -a "$LOGFILE"
echo "========================================" | tee -a "$LOGFILE"
echo " Maintenance complete!" | tee -a "$LOGFILE"
echo " Log saved to: $LOGFILE" | tee -a "$LOGFILE"
echo "========================================" | tee -a "$LOGFILE"
echo ""
read -p "Press ENTER to close..."
