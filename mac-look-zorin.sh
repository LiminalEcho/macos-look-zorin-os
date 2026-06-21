#!/bin/bash

# =============================================================
# macOS Look for Zorin OS 17 Core - Automated Install Script
# Tested on: Zorin OS 17 Core (Ubuntu 22.04 base, GNOME 46)
# Hardware tested: MacBook Air 2013
# =============================================================

set -e

echo "================================================"
echo " macOS Look - Zorin OS 17 Setup Script"
echo "================================================"
echo ""
echo "This script will install:"
echo "  - mac-plymouth (Apple boot screen)"
echo "  - WhiteSur GTK dark theme"
echo "  - WhiteSur wallpapers"
echo "  - WhiteSur GDM login screen"
echo "  - McMojave cursors"
echo "  - Boot time optimizations"
echo "  - Firewall"
echo ""
read -p "Press ENTER to continue or CTRL+C to cancel..."

# =============================================================
# 1. SYSTEM UPDATE
# =============================================================
echo ""
echo "[1/8] Updating system..."
sudo apt update && sudo apt upgrade -y

# =============================================================
# 2. INSTALL DEPENDENCIES
# =============================================================
echo ""
echo "[2/8] Installing dependencies..."
sudo apt install -y git imagemagick sassc dbus-x11 curl wget

# =============================================================
# 3. PLYMOUTH BOOT SCREEN (Apple logo)
# =============================================================
echo ""
echo "[3/8] Installing Apple Plymouth boot screen..."
cd ~
git clone https://github.com/fathyar/mac-plymouth.git
cd mac-plymouth
sudo cp -r mac /usr/share/plymouth/themes
sudo update-alternatives --install \
  /usr/share/plymouth/themes/default.plymouth \
  default.plymouth \
  /usr/share/plymouth/themes/mac/mac.plymouth 100
sudo update-alternatives --set \
  default.plymouth \
  /usr/share/plymouth/themes/mac/mac.plymouth
sudo update-initramfs -u
cd ~

# =============================================================
# 4. WHITESUR THEME + WALLPAPERS + GDM
# =============================================================
echo ""
echo "[4/8] Installing WhiteSur theme..."
cd ~
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme

# Install desktop theme (dark)
./install.sh -c Dark

# Install wallpapers
git clone https://github.com/vinceliuice/WhiteSur-wallpapers.git
cd WhiteSur-wallpapers
./install-gnome-backgrounds.sh
cd ..

# Install GDM login screen
sudo ./tweaks.sh -g
cd ~

# =============================================================
# 5. McMOJAVE CURSORS
# =============================================================
echo ""
echo "[5/8] Installing McMojave cursors..."
cd ~
git clone https://github.com/yeyushengfan258/McMojave-cursors.git
cd McMojave-cursors
./install.sh
cd ~

# =============================================================
# 6. WHITESUR ICON THEME
# =============================================================
echo ""
echo "[6/8] Installing WhiteSur icons..."
cd ~
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme
./install.sh
cd ~

# =============================================================
# 7. BOOT OPTIMIZATIONS
# =============================================================
echo ""
echo "[7/8] Applying boot optimizations..."

# Disable NetworkManager wait (saves ~6 seconds)
sudo systemctl disable NetworkManager-wait-online.service

# Disable snapd seeded (saves ~1 second)
sudo systemctl disable snapd.seeded.service

# Reduce swappiness for SSD
if ! grep -q "vm.swappiness=10" /etc/sysctl.conf; then
  echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
  sudo sysctl -p
fi

# Plymouth config
sudo bash -c 'cat > /etc/plymouth/plymouthd.conf << EOF
[Daemon]
Theme=mac
ShowDelay=0
EOF'

# =============================================================
# 8. SECURITY - ENABLE FIREWALL
# =============================================================
echo ""
echo "[8/8] Enabling firewall..."
sudo ufw --force enable

# =============================================================
# CLEANUP
# =============================================================
echo ""
echo "Cleaning up..."
sudo apt autoremove -y
sudo apt clean

# =============================================================
# DONE
# =============================================================
echo ""
echo "================================================"
echo " Installation complete!"
echo "================================================"
echo ""
echo "MANUAL STEPS STILL REQUIRED:"
echo ""
echo "1. Open GNOME Tweaks > Appearance and set:"
echo "   - Shell:               WhiteSur-Dark-solid"
echo "   - Icons:               WhiteSur-light"  
echo "   - Cursor:              McMojave-cursors"
echo "   - Legacy Applications: ZorinBlue-Dark (or WhiteSur-Dark-solid)"
echo ""
echo "2. Open Zorin Appearance:"
echo "   - Select the bottom dock layout"
echo "   - Go to Windows > set buttons to Left"
echo ""
echo "3. Remove GDM logo (optional):"
echo "   sudo rm -rf /var/lib/gdm3/.config/dconf"
echo ""
echo "4. Reboot:"
echo "   sudo reboot"
echo ""
echo "MONTHLY MAINTENANCE:"
echo "   sudo apt update && sudo apt upgrade -y"
echo "   sudo fwupdmgr refresh && sudo fwupdmgr update"
echo "   sudo apt autoremove -y && sudo apt clean"
echo "   sudo journalctl --vacuum-time=7d"
echo "   rm -rf ~/.local/share/Trash/*"
echo ""
