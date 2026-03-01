# 💧 Sipster

A native macOS menu bar app that gently reminds you to stay hydrated throughout the day. 

> Note from Bhavik: Wanted to test out Claude Code so thought of having a quick vibecode session with it. Love the output -- feel free to use/contribute/distribute at your own risk! :D

![macOS 14+](https://img.shields.io/badge/macOS-14%2B-blue?logo=apple)
![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-orange?logo=swift)
![CI](https://github.com/whihathac/sipster/actions/workflows/ci.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-green)

---

## Features

- **🔔 Smart Reminders** — Configurable intervals (15 min – 4 hrs), active hours, and specific days of the week
- **💧 Floating Water Drop** — A persistent overlay appears on reminders; click it to log a drink and dismiss it
- **⏱ Countdown Timer** — The overlay shows a live 15-minute timer with urgency colour transitions
- **📊 Daily Progress Ring** — See your hydration percentage at a glance in the menu bar (fill level animates as you drink)
- **📈 Weekly Dashboard** — Bar chart and stats (daily average, best day, goal-met days, streak) across the past week
- **⚡ Quick-Add from Menu Bar** — One-click logging for Glass (150 ml), Cup (250 ml), and Bottle (500 ml)
- **🎵 Sound Feedback** — Optional audio cue when logging a drink
- **🚀 Launch at Login** — Start Sipster automatically when you log in
- **🔕 Snooze / Pause** — Temporarily pause reminders when you need focus time
- **📋 Drink History** — Scrollable log of today's drinks with timestamps and amounts

---

## Requirements

| Requirement | Version |
|-------------|---------|
| macOS | **14 (Sonoma)** or later |
| Swift | 5.9+ |
| Xcode | **16+** (required for Swift Testing; install from the App Store) |

---

## Installation

### Download (recommended for everyday use)

1. Go to the [**Releases**](../../releases) page
2. Download the latest `Sipster-vX.Y.Z.zip`
3. Unzip and drag **Sipster.app** into `/Applications`
4. Right-click → **Open** on the first launch (to bypass Gatekeeper on unsigned builds)

Sipster will appear in your menu bar — no Dock icon, no clutter.

### Build from Source

#### 1. Prerequisites

Install **Xcode 16+** from the Mac App Store (or download from [developer.apple.com](https://developer.apple.com/xcode/)):

```bash
# Verify Xcode is installed and command-line tools are active
xcode-select -p
# Expected output: /Applications/Xcode.app/Contents/Developer

# If that path doesn't appear, set it manually:
sudo xcode-select -s /Applications/Xcode.app

# Verify Swift version (should be 5.9+)
swift --version
```

> **Note:** Command Line Tools alone (`xcode-select --install`) is **not enough** — the Swift Testing framework used by the test suite requires the full Xcode app.

#### 2. Clone the repository

```bash
git clone https://github.com/whihathac/sipster.git
cd sipster
```

#### 3. First build

```bash
# Assemble the full .app bundle (binary + Info.plist + ad-hoc codesign)
bash build.sh

# Launch Sipster
open .build/release/Sipster.app
```

Sipster's water-drop icon will appear in your menu bar. On the very first run, macOS may ask for notification permission — allow it so reminder alerts work.

---

## Day-to-Day Usage

| Action | How |
|--------|-----|
| Log a drink | Click the floating water drop **or** use Quick-Add in the menu bar |
| Open Dashboard | Click the menu bar icon → **Open Dashboard** |
| Open Preferences | Click the menu bar icon → **Settings…** (or `⌘,`) |
| Dismiss overlay | Click anywhere on the drop, or wait for it to expire |
| Quit | Menu bar → **Quit Sipster** |

### Preferences

| Tab | Options |
|-----|---------|
| **General** | Daily goal (glasses), reminder interval, sound on/off, launch at login |
| **Schedule** | Active hours (start/end time), active days of the week |
| **About** | Version info |

---

## Day-to-Day Development

### Common workflow

```bash
# 1. Make your changes to sources under Sources/SipsterLib/ or Sources/Sipster/

# 2. Quick compile check (no .app bundle — fast feedback)
swift build

# 3. Quit any running instance before relaunching
pkill -x Sipster || true
# or from the app: menu bar → Quit Sipster

# 4. Build the full .app bundle and launch
bash build.sh && open .build/release/Sipster.app
```

> Because Sipster runs as `LSUIElement` (menu-bar only, no Dock icon), there is no window to close — you must quit from the menu bar or with `pkill` before relaunching a new build.

### Run the tests

```bash
swift test              # run all tests
swift test --parallel   # faster (tests are independent)
```

### Resetting app state

```bash
# Clear all drink log data
rm ~/Library/Application\ Support/Sipster/drinks.json

# Reset all settings (UserDefaults) to defaults
defaults delete com.sipster.app

# Do both at once
rm ~/Library/Application\ Support/Sipster/drinks.json && defaults delete com.sipster.app
```

### Quick reference

| Task | Command |
|------|---------|
| Compile check | `swift build` |
| Full app build | `bash build.sh` |
| Launch app | `open .build/release/Sipster.app` |
| Quit app (terminal) | `pkill -x Sipster` |
| Run tests | `swift test --parallel` |
| Reset drink data | `rm ~/Library/Application\ Support/Sipster/drinks.json` |
| Reset settings | `defaults delete com.sipster.app` |
| View live logs | `log stream --predicate 'process == "Sipster"'` |
| Check codesign | `codesign --verify --verbose .build/release/Sipster.app` |

---

## Architecture

Sipster is built entirely with Apple system frameworks — no external dependencies.

```
Sources/
├── Sipster/               # Executable target (@main entry point)
│   └── SipsterApp.swift   # MenuBarExtra + Window + Settings scenes
└── SipsterLib/            # Library target (all app logic, testable)
    ├── Models/
    │   ├── DrinkLog.swift        # Codable drink event (timestamp, amount, source)
    │   ├── DrinkSize.swift       # Enum: Glass / Cup / Bottle
    │   ├── DayRecord.swift       # Daily aggregation
    │   └── UserSettings.swift    # @AppStorage-backed settings
    ├── Services/
    │   ├── DataStore.swift       # JSON file persistence
    │   ├── ReminderManager.swift # Timer scheduling + overlay management
    │   ├── SoundManager.swift    # NSSound wrapper
    │   └── LaunchAtLoginManager.swift
    ├── Views/
    │   ├── MenuBar/              # Popover + dynamic fill-level icon
    │   ├── Dashboard/            # Progress ring, charts, stats, drink list
    │   ├── Preferences/          # General, Schedule, About tabs
    │   └── Overlay/              # NSPanel floating water-drop overlay
    └── Utilities/
        ├── Constants.swift
        ├── DateExtensions.swift
        └── NotificationHelper.swift

Tests/
└── SipsterTests/          # Swift Testing unit tests
    ├── DrinkLogTests.swift
    ├── DateExtensionsTests.swift
    ├── DrinkLogArrayTests.swift
    ├── DataStoreTests.swift
    └── UserSettingsTests.swift
```

### Key design decisions

| Decision | Rationale |
|----------|-----------|
| `LSUIElement = true` | Menu bar-only app — no Dock icon |
| `NSPanel` (borderless, non-activating) | Floating overlay without stealing keyboard focus |
| JSON file persistence | SwiftData macros are incompatible with SPM command-line builds |
| `@AppStorage` for settings | Zero-boilerplate key-value persistence via UserDefaults |
| Library/executable split | All core logic in `SipsterLib` so it can be unit-tested |
| Timer-based reminders | Fires at next calculated time, then reschedules — avoids drift |

---

## Development

### Project structure conventions

- All types in `SipsterLib` are `public` to be visible to the test target
- `DataStore` has a `public init(fileURL:)` for injecting a temp file in tests
- Views use `@StateObject` / `@EnvironmentObject` — no global singletons in view code

### Adding a new drink size

1. Add a case to `DrinkSize` in `Sources/SipsterLib/Models/DrinkSize.swift`
2. Update `DrinkSizeTests.swift` to cover the new case

---

## CI / CD

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| **CI** | Push to `main`/`develop`, PRs | `swift build -c release` → `swift test --parallel` → `bash build.sh` → verify bundle |
| **Release** | Push a `vX.Y.Z` tag | CI steps + zip `.app` + create GitHub Release with SHA256 checksum |

To cut a release:

```bash
git tag v1.1.0
git push origin v1.1.0
```

The release workflow publishes a downloadable `Sipster-v1.1.0.zip` automatically.

---

## Data & Privacy

- All data stays **100% local** — no network requests, no analytics, no telemetry
- Drink logs: `~/Library/Application Support/Sipster/drinks.json`
- Settings: `UserDefaults` (`com.sipster.app` domain)

---

## Contributing

Contributions are welcome! Please:

1. Fork the repo and create a feature branch (`git checkout -b feat/my-feature`)
2. Write or update tests for your changes
3. Run `swift test` and `bash build.sh` before opening a PR
4. Open a Pull Request — the CI will run automatically

### Reporting bugs

Please open a [GitHub Issue](../../issues) with:
- macOS version
- Sipster version (About tab in Preferences)
- Steps to reproduce

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

*Built with SwiftUI, Swift Charts, and AppKit on macOS Sonoma using Claude Code.*
