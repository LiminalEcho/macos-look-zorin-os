# macOS Look on Zorin OS — Complete Setup Guide

> Transform your MacBook running Zorin OS 17 Core into a clean, fast, macOS-style Linux desktop. No Pro license required.

[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](LICENSE)
[![Zorin OS](https://img.shields.io/badge/Zorin%20OS-17%20Core-blue.svg)](https://zorin.com)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20Base-orange.svg)](https://ubuntu.com)
[![GNOME](https://img.shields.io/badge/GNOME-46-green.svg)](https://gnome.org)

---

## What This Guide Does

This repository provides a complete, tested setup to make Zorin OS 17 Core look and feel like macOS on a MacBook. Every step has been verified on a **MacBook Air 2013** running **Zorin OS 17 Core** with **GNOME 46 on Wayland**.

**No unstable extensions. No Pro license. No gimmicks.**

---

## Preview

| Component | Before | After |
|---|---|---|
| Boot screen | Zorin logo | Apple Plymouth animation |
| Login screen | Zorin GDM | WhiteSur Dark |
| Desktop theme | Zorin default | WhiteSur Dark |
| Icons | Zorin icons | WhiteSur light |
| Cursor | Default | McMojave |
| Fonts | Default | Inter + JetBrains Mono |
| Dock | Left side | Bottom centered |
| Window buttons | Right | Left (macOS style) |
| Boot time | ~15s | ~7s |
| Battery life | ~3.5h | ~5.8h |

---

## Quick Install

Clone this repository and run the automated install script:

```bash
git clone https://github.com/LiminalEcho/macos-look-zorin-os.git
cd macos-look-zorin-os
chmod +x scripts/mac-look-zorin.sh
./scripts/mac-look-zorin.sh
```

Then follow the short manual steps printed at the end of the script.

---

## What Is Included

```
macos-look-zorin-os/
├── guides/
│   └── mac-look-zorin-guide.md    # Full step-by-step guide (18 steps)
├── scripts/
│   ├── mac-look-zorin.sh          # Automated install script
│   └── zorin-maintenance.sh       # Monthly maintenance script
└── docs/
    └── index.html                 # GitHub Pages landing page
```

---

## Guide Overview

The full guide covers 18 steps:

1. Apple Plymouth boot screen
2. WhiteSur Dark GTK theme
3. McMojave cursors
4. WhiteSur icon theme
5. Remove GDM logo
6. Inter fonts + JetBrains Mono
7. macOS Big Sur sound theme
8. Dock layout + left window buttons
9. Mac-like touchpad scrolling
10. Lid close suspend
11. Boot time optimization
12. SSD optimization
13. Battery optimization with TLP
14. Fan control with mbpfan
15. UFW firewall
16. Timeshift system backup
17. RAM optimization (ZRAM + Tab Suspender)
18. macOS-style keyboard shortcuts

---

## Tested Hardware

| Hardware | OS | Result |
|---|---|---|
| MacBook Air 2013 (i5, 4GB RAM, 128GB SSD) | Zorin OS 17 Core | Fully working |

---

## Requirements

- Zorin OS 17 Core (Ubuntu 22.04 base)
- GNOME 46
- Wayland session
- Internet connection
- sudo access

---

## Read The Full Guide

[Full Step-by-Step Guide](guides/mac-look-zorin-guide.md)

---

## Monthly Maintenance

Keep your system clean and updated with the included maintenance script:

```bash
chmod +x scripts/zorin-maintenance.sh
./scripts/zorin-maintenance.sh
```

Runs: system updates, firmware updates, package cleanup, log cleanup and trash empty.

---

## License

MIT License. See [LICENSE](LICENSE) for details.

---

## Keywords

zorin os macos theme, zorin os macbook, linux macos look, whitesur zorin, zorin os customization, macos gnome theme, linux macbook air, zorin os 17 setup, gnome macos theme ubuntu
