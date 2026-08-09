# Automotive HMI - AutoPlayer
![C++](https://img.shields.io/badge/C%2B%2B-17-00599C?style=flat-square&logo=c%2B%2B)
![Qt](https://img.shields.io/badge/Qt-6.7.2-41CD52?style=flat-square&logo=qt)
![Android](https://img.shields.io/badge/Android-Head_Unit_Tested-3DDC84?style=flat-square&logo=android)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=flat-square&logo=github-actions)
![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)

> A modern, high-contrast, dark-monochrome Automotive HMI Media Player designed for in-car infotainment systems. Built with **C++17**, **Qt 6 (QML)**, and **CMake**.
> **Successfully deployed and practically tested on real-world Android Car Head Units (Android 9 / ARMv7).**

---

## Design Philosophy & HMI Ergonomics

Inspired by minimalist aesthetics, this **HMI** strictly follows automotive UX guidelines to ensure driver safety and usability:

*   **Dark Monochrome Theme**: Optimized for night driving to reduce cabin glare and protect night vision.
*   **High Contrast & Legibility**: Pure white elements over a deep black background (`#0A0A0C`) for instantaneous readability within 2-second glance times.
*   **Touch-Friendly Hitboxes**: Oversized buttons ($70\times70\text{px}+$ target areas) and thick sliders designed for physical feedback during vehicle vibration.
*   **Non-Blocking UI**: Asynchronous file scanning and data fetching ensure consistent 60 FPS UI rendering, even when reading from external car peripherals.

---

## Features & Hardware Integration

*   **Real-world Head Unit Ready**: Cross-compiled specifically for 32-bit automotive Android environments.
*   **Physical USB Auto-Sync**: Custom background watcher to detect, mount, and scan physical USB drives plugged into the car's hardware interfaces.
*   **Automated CI/CD Pipeline**: Integrated GitHub Actions workflow to automatically compile, build, and sign Android APKs upon deployment.
*   **Audio & Video Playback**: Full support for `.mp3`, `.flac`, `.mp4` formats powered by `QtMultimedia`.
*   **Vinyl Visualizer**: Smooth rotating album art animation synchronized with playback states.
*   **Media Library**: Smart list virtualization using `QAbstractListModel` for smooth scrolling through thousands of tracks without memory spikes.
*   **Safety Override Settings**: Configurable safety toggles (e.g., *Allow Video While Driving*) to comply with standard automotive software regulations.

---

## Project Architecture

The project follows a strict **3-Tier Clean Architecture** separating UI, Business Logic, and Hardware/Core operations:

```text
Media-Player/
├── ui/                     # QML Frontend
│   ├── components/         # Reusable HMI controls (CustomSlider, PlaybackControls, SideBar, TrackDelegate)
│   ├── views/              # Main screens (PlayerView, MediaLibraryView, SettingsView)
│   └── main.qml            # Root window & StackLayout navigation
└── src/                    # C++ Backend
    ├── core/               # Engine & Hardware I/O (MediaEngine, UsbScanner)
    ├── controllers/        # QML Bridge & State Management (PlaybackController, SettingsController)
    └── models/             # Data Models & Virtualization (MediaModel, TrackItem)
```
## Tech Stack & Requirements
- **Language:** C++17 / QML
- **Framework:** Qt 6.7.2 (Qt Quick, Qt Quick Controls, Qt Multimedia)
- **Build System:** CMake 3.16+

- **Targets:** Linux x86_64 (Desktop) & Android ARMv7 (Automotive Embedded)

- **Tooling:** GitHub Actions, apksigner, JDK 17

---
## Building & Running
1. Local Linux Desktop Build
```bash
git clone [https://github.com/NarieWynn/Media-Player.git](https://github.com/NarieWynn/Media-Player.git)
cd Media-Player
mkdir build && cd build
cmake ..
make -j$(nproc)
./appAutoPlayer
```
2. Android Car Head Unit Deployment (APK)
   The project utilizes GitHub Actions for automated Android builds.

   1. Navigate to the Actions tab in this repository.

   2. Select the Build Android APK (32-bit) workflow.

   3. Download the signed .apk artifact.

   4. Transfer to a USB drive and install directly onto the vehicle's Android head unit.
---
## License
Distributed under the MIT License. See LICENSE for more information.