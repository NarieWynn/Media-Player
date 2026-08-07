# Automotive HMI - Music & Media Player
![C++](https://img.shields.io/badge/C%2B%2B-17-00599C?style=flat-square&logo=c%2B%2B)
![Qt](https://img.shields.io/badge/Qt-6.x-41CD52?style=flat-square&logo=qt)
![CMake](https://img.shields.io/badge/CMake-3.16%2B-064F8C?style=flat-square&logo=cmake)
![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)
> A modern, high-contrast, dark-monochrome Automotive HMI Media Player designed for in-car infotainment systems. Built with **C++20**, **Qt 6 (QML)**, and **CMake**.

---

## Design Philosophy & HMI Ergonomics

Inspired by minimalist manga/cyberpunk aesthetics, **Vortex HMI** strictly follows automotive UX guidelines:

*   **Dark Monochrome Theme**: Optimized for night driving to reduce cabin glare and protect night vision.
*   **High Contrast & Legibility**: Pure white elements over deep black background (`#0A0A0C`) for instantaneous readability within 2-second glance times.
*   **Touch-Friendly Hitboxes**: Oversized buttons ($70\times70\text{px}+$ target areas) and thick sliders designed for physical feedback during vehicle vibration.
*   **Non-Blocking UI**: Asynchronous file scanning and data fetching ensure consistent 60 FPS UI rendering.

---

## Features

*   **Audio & Video Playback**: Full support for `.mp3`, `.flac`, `.mp4` formats powered by `QtMultimedia`.
*   **Vinyl Visualizer**: Smooth rotating album art animation synchronized with playback states.
*   **Media Library**: Smart list virtualization using `QAbstractListModel` for smooth scrolling through thousands of tracks.
*   **Metadata Parsing**: Automatic fallback mechanism — parses ID3 tags or extracts artist/title directly from filenames.
*   **Safety Override Settings**: Configurable safety toggles (e.g., *Allow Video While Driving*) and system audio volume sliders.

---

## Project Architecture

The project follows a strict **3-Tier Clean Architecture** separating UI, Business Logic, and Hardware/Core operations:

```text
Music-Player/
├── ui/                     # QML Frontend
│   ├── components/         # Reusable HMI controls (CustomSlider, PlaybackControls, SideBar, TrackDelegate)
│   ├── views/              # Main screens (PlayerView, MediaLibraryView, SettingsView)
│   └── main.qml            # Root window & StackLayout navigation
└── src/                    # C++ Backend
    ├── core/               # Engine & Hardware I/O (MediaEngine, UsbScanner)
    ├── controllers/        # QML Bridge & State Management (PlaybackController, SettingsController)
```
---
## Tech Stack & Requirements

- Language: C++20 / QML

- Framework: Qt 6.5+ (Qt Quick, Qt Quick Controls, Qt Multimedia)

- Build System: CMake 3.16+

- Compiler: GCC / Clang (Linux x86_64 or ARM64 embedded targets)
---
## Building & Running
1. Clone the repository
```bash
git clone [https://github.com/NarieWynn/Music-Player.git](https://github.com/NarieWynn/Music-Player.git)
cd Music-Player
```
2. Build with CMake
```bash
mkdir build && cd build
cmake ..
make -j$(nproc)
```
3. Run the Application
```bash
./appAutoPlayer 
```
---
## License

Distributed under the MIT License. See LICENSE for more information.