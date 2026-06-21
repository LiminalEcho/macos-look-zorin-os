# macOS Look on Zorin OS 17 Core
### A complete customization guide for old MacBooks and any Ubuntu-based PC

---

## Overview

This guide transforms Zorin OS 17 Core into a clean macOS-style desktop. It covers boot screen, login screen, desktop theme, dock, icons, cursors, fonts, sound, touchpad, battery optimization, and security. Everything here uses free, open-source tools unless otherwise noted.

**Tested on:** MacBook Air 2013, Zorin OS 17 Core (Ubuntu 22.04, GNOME 46, Wayland)

---

## Quick Install

If you want to skip the manual steps, use the automated script:

```bash
chmod +x mac-look-zorin.sh
./mac-look-zorin.sh
```

Then follow the manual steps at the end of the script output.

---

## Step-by-Step Guide

### 1. Apple Plymouth Boot Screen

Replaces the Zorin boot logo with an Apple-style animation.

```bash
sudo apt install git
git clone https://github.com/fathyar/mac-plymouth.git && cd mac-plymouth
sudo cp -r mac /usr/share/plymouth/themes
sudo update-alternatives --install \
  /usr/share/plymouth/themes/default.plymouth \
  default.plymouth \
  /usr/share/plymouth/themes/mac/mac.plymouth 100
sudo update-alternatives --config default.plymouth
sudo update-initramfs -u
```

**Preview without rebooting:**
```bash
sudo plymouthd; sudo plymouth --show-splash; sleep 5; sudo plymouth --quit
```

**Plymouth config** (`/etc/plymouth/plymouthd.conf`):
```
[Daemon]
Theme=mac
ShowDelay=0
```

---

### 2. WhiteSur Dark Theme

Installs the macOS Big Sur inspired GTK theme, wallpapers, and GDM login screen.

```bash
sudo apt install imagemagick sassc
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme

# Install desktop theme
./install.sh -c Dark

# Install wallpapers
git clone https://github.com/vinceliuice/WhiteSur-wallpapers.git
cd WhiteSur-wallpapers && ./install-gnome-backgrounds.sh && cd ..

# Install GDM login/lock screen
sudo ./tweaks.sh -g
```

**Apply in GNOME Tweaks > Appearance:**

| Setting | Value |
|---|---|
| Shell | WhiteSur-Dark-solid |
| Icons | WhiteSur-light |
| Cursor | McMojave-cursors |
| Legacy Applications | ZorinBlue-Dark or WhiteSur-Dark-solid |

**Light theme users:** The same steps work with the light variants. Replace `-c Dark` with `-c Light` in the install command and set Shell and Legacy Applications to `WhiteSur-Light` or `WhiteSur-Light-solid` in GNOME Tweaks. The GDM and wallpaper steps are identical.

---

### 3. McMojave Cursors

```bash
git clone https://github.com/yeyushengfan258/McMojave-cursors.git
cd McMojave-cursors && ./install.sh
```

Then set in GNOME Tweaks > Appearance > Cursor.

---

### 4. WhiteSur Icon Theme

```bash
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme && ./install.sh
```

Then set in GNOME Tweaks > Appearance > Icons.

---

### 5. Remove GDM Logo

The Zorin logo on the login screen requires two steps. First set the logo to empty in the GDM config, then reset the dconf database.

**Step 1:** Open the GDM config file:
```bash
sudo nano /etc/gdm3/greeter.dconf-defaults
```

Find the logo line and set it to empty (remove the `#` and clear the path):
```
logo=''
```

Save with Ctrl+X, then Y, then Enter.

**Step 2:** Apply and reset:
```bash
sudo dconf update
sudo rm -rf /var/lib/gdm3/.config/dconf
sudo reboot
```

---

### 6. Fonts

Install Inter, the closest free alternative to Apple's San Francisco font:

```bash
sudo apt install fonts-inter fonts-jetbrains-mono
```

Then open **GNOME Tweaks > Fonts** and set:

| Field | Value |
|---|---|
| Interface Text | `Inter Regular 11` |
| Document Text | `Inter Regular 11` |
| Monospace Text | `JetBrains Mono Regular 11` |
| Legacy Window Titles | `Inter Bold 11` |
| Antialiasing | `Subpixel (for LCD screens)` |
| Hinting | `Slight` |

**Note:** Subpixel antialiasing is the best choice for the non-retina display on MacBook Air 2013. Slight hinting keeps font shapes clean without distortion.

---

### 7. macOS Sound Theme

Install the macOS Big Sur sound theme:

```bash
git clone https://github.com/gxanshu/macos-bigsur-sound-theme-linux.git
cd macos-bigsur-sound-theme-linux
mkdir -p ~/.local/share/sounds
cp -r theme ~/.local/share/sounds/bigsur
```

Activate it:
```bash
gsettings set org.gnome.desktop.sound theme-name 'bigsur'
gsettings set org.gnome.desktop.sound event-sounds true
```

**Note:** The sounds are extracted from macOS Big Sur and are technically Apple's property. Use at your own discretion.

---

### 8. Dock and Layout

Open **Zorin Appearance** from the app menu:

- Go to **Layout** and select the bottom dock layout (grid of squares with dock at bottom)
- Go to **Windows** and set titlebar buttons to **Left**

This gives you the macOS-style centered bottom dock with window controls on the left.

---

### 9. Touchpad - Mac-like Scrolling and Gestures

```bash
sudo apt install xserver-xorg-input-libinput
sudo nano /etc/X11/xorg.conf.d/30-touchpad.conf
```

Add this content:
```
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "NaturalScrolling" "true"
    Option "ScrollPixelDistance" "60"
    Option "Accel Speed" "0.3"
    Option "Tapping" "on"
    Option "TappingDrag" "on"
    Option "DisableWhileTyping" "on"
EndSection
```

Reboot to apply. The `ScrollPixelDistance` of 60 gives the closest feel to macOS scrolling. Adjust between 50-75 to taste.

---

### 10. Lid Close - Suspend on Clamshell

```bash
sudo nano /etc/systemd/logind.conf
```

Set these values:
```
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=suspend
```

Apply without rebooting:
```bash
sudo systemctl restart systemd-logind
```

---

### 11. Boot Time Optimization

Run these once to reduce boot time by approximately 7 seconds:

```bash
# Disable NetworkManager wait (~6 seconds saved)
sudo systemctl disable NetworkManager-wait-online.service

# Disable snapd seeded (~1 second saved)
sudo systemctl disable snapd.seeded.service
```

Check your boot time before and after:
```bash
systemd-analyze
systemd-analyze blame | head -20
```

**Note:** Keep `fwupd.service` enabled for firmware security updates.

---

### 12. SSD Optimization

Reduces swap usage which improves performance and extends SSD lifespan:

```bash
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

---

### 13. Battery Optimization - TLP

Install TLP for automatic power management:

```bash
sudo apt install tlp tlp-rdw
sudo systemctl enable tlp
sudo systemctl start tlp
```

Verify TLP is running:
```bash
sudo tlp-stat -s
```

Check battery health anytime:
```bash
upower -i $(upower -e | grep battery)
```

**Note:** Do not install TLP alongside `power-profiles-daemon` as they conflict. Disable it first if active:
```bash
sudo systemctl disable power-profiles-daemon
```

---

### 14. Fan Control - mbpfan

Manages the MacBook fan automatically based on SMC temperature sensors:

```bash
sudo apt install mbpfan
sudo systemctl enable mbpfan
sudo systemctl start mbpfan
```

Verify it is running:
```bash
sudo systemctl status mbpfan
```

---

### 15. Security - Enable Firewall

```bash
sudo ufw enable
sudo ufw status
```

---

### 16. System Backup - Timeshift

Install Timeshift and create a recovery point:

```bash
sudo apt install timeshift
```

Open Timeshift from the app menu, select RSYNC as snapshot type. In the Setup Wizard under User Home Directories, select **Include Only Hidden Files** for both users to capture customization settings without backing up all personal files.

Create your first snapshot manually:
```bash
sudo timeshift --create --comments "macOS setup complete - $(date +%Y-%m-%d)"
```

---

### 17. RAM Optimization (4GB Systems)

Critical for MacBook Air 2013 which has only 4GB RAM. These steps free up approximately 1.3GB of RAM.

**Check current RAM usage:**
```bash
free -h
```

**1. Install ZRAM (compressed RAM - most impactful):**
```bash
sudo apt install zram-config
sudo reboot
```

ZRAM creates compressed swap in RAM itself, effectively giving more usable memory. Swap usage will drop dramatically after this.

**2. Remove GNOME file indexer (tracker):**
```bash
sudo apt remove tracker tracker-miner-fs -y
sudo apt autoremove -y
```

**3. Disable GNOME remote desktop:**
```bash
sudo systemctl disable gnome-remote-desktop.service
sudo systemctl stop gnome-remote-desktop.service
```

**4. Reduce swappiness further:**

Edit `/etc/sysctl.conf` and change:
```
vm.swappiness=5
```

Apply:
```bash
sudo sysctl -p
```

**5. Install Tab Suspender in Brave:**

This is the single most impactful step. Brave with 10-20 tabs can consume 3.6GB of RAM alone. Tab Suspender automatically suspends inactive tabs.

Install from the Chrome Web Store inside Brave:
```
https://chromewebstore.google.com/detail/tab-suspender/fiabciakcmgepblmdkmemdbbkilneeeh
```

Configure it to suspend tabs after 15-30 minutes of inactivity.

**Check Brave RAM usage:**
```bash
ps aux | grep brave | awk '{print $6}' | awk '{sum+=$1} END {print sum/1024 " MB"}'
```

**Expected results after all steps:**

| Metric | Before | After |
|---|---|---|
| RAM used | 3.1GB | 1.8GB |
| RAM available | 630MB | 2.0GB |
| Swap used | 1.8GB | 858MB |

---

### 18. macOS-style Keyboard Shortcuts

**Step 1: Swap Command and Ctrl keys**

On a Mac keyboard, the Command key registers as Super in Linux. This swap makes Command behave like Ctrl so copy/paste/cut and all window shortcuts work from the Command key:

```bash
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swap_lwin_lctl']"
```

Log out and back in for the key swap to take effect.

**Step 2: Verify Command key registers correctly**

```bash
xev | grep keysym
```

Press Command key. It should show `Control_L`.

**Step 3: Clear the overlay key so Command does not trigger Activities**

```bash
gsettings set org.gnome.mutter overlay-key ''
```

**Step 4: Apply all shortcuts**

Create and run the shortcuts script:

```bash
nano ~/mac-shortcuts.sh
```

Paste this content:

```bash
#!/bin/bash

echo "Applying macOS-style keyboard shortcuts..."

# Spotlight-style search with Cmd+Space
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Primary>space']"

# Window management
gsettings set org.gnome.desktop.wm.keybindings close "['<Primary>q']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Primary>m']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Primary>f']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Primary>h']"

# Switch applications like Cmd+Tab on Mac
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Primary>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Primary><Shift>Tab']"

# Screenshots like Mac
gsettings set org.gnome.shell.keybindings screenshot "['<Primary><Shift>3']"
gsettings set org.gnome.shell.keybindings screenshot-window "['<Primary><Shift>4']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Primary><Shift>5']"

# Fix conflict - move input source switcher
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['XF86Keyboard']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift>XF86Keyboard']"

echo "Done."
```

Save with Ctrl+X, then Y, then Enter, then run:

```bash
chmod +x ~/mac-shortcuts.sh
./mac-shortcuts.sh
```

**Working shortcuts after setup:**

| Shortcut | Action |
|---|---|
| Cmd+C/V/X | Copy/Paste/Cut |
| Cmd+Q | Close window |
| Cmd+M | Minimize |
| Cmd+H | Hide window |
| Cmd+F | Fullscreen |
| Cmd+Tab | Switch apps |
| Cmd+Shift+Tab | Switch apps backward |
| Cmd+Space | Search/Spotlight |
| Cmd+Shift+3 | Screenshot |
| Cmd+Shift+4 | Screenshot window |
| Cmd+Shift+5 | Screenshot tool |

**Note:** This setup is specific to Mac keyboards where the Command key is next to the spacebar. The key swap only works correctly when confirmed via `xev` showing Command as `Control_L`.

---

## Monthly Maintenance Routine

Run this once a month to keep the system clean and updated:

```bash
sudo apt update && sudo apt upgrade -y
sudo fwupdmgr refresh && sudo fwupdmgr update
sudo apt autoremove -y && sudo apt clean
sudo journalctl --vacuum-time=7d
rm -rf ~/.local/share/Trash/*
```

A desktop launcher script (`zorin-maintenance.sh`) is also available to run this with a single click from the app menu.

---

## Final Result

| Component | Solution |
|---|---|
| Boot screen | mac-plymouth (Apple logo) |
| Login / lock screen | WhiteSur Dark GDM, no logo |
| Desktop theme | WhiteSur-Dark-solid (Shell) |
| App theme | ZorinBlue-Dark (Legacy Applications) |
| Icons | WhiteSur-light |
| Cursor | McMojave-cursors |
| Fonts | Inter Regular + JetBrains Mono |
| Sound theme | macOS Big Sur |
| Dock | Bottom centered, macOS style |
| Window buttons | Left side |
| Touchpad | Natural scrolling, tap to click |
| Lid close | Suspend |
| Battery | TLP + mbpfan |
| Firewall | UFW enabled |
| Swappiness | 10 (SSD optimized) |
| RAM optimization | ZRAM + Tab Suspender + tracker removed |
| Keyboard shortcuts | macOS-style via Command key |
| Backup | Timeshift snapshot |

---

## Notes

- This guide uses only tools maintained by active open-source projects unless otherwise noted
- All changes are reversible
- Tested on Wayland - no unstable extensions required
- The Pro version of Zorin OS offers more layout options but is not required for this setup
- Keep firmware updates (`fwupd`) enabled for security even if other boot services are disabled
- The macOS sound theme uses Apple's audio assets - use at your own discretion

---

*Guide created April 2026*
