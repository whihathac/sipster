# Sipster - macOS Water Reminder App

## Project Overview
A native macOS menu bar app that reminds users to drink water. Built with SwiftUI, AppKit, and Swift Charts. Data persisted to JSON (not SwiftData — macros are incompatible with SPM command-line builds).

## Tech Stack
- **Language:** Swift 5.9+
- **UI:** SwiftUI (macOS 14+ / Sonoma)
- **Data:** JSON file persistence with `Codable` + `ObservableObject` DataStore; `@AppStorage` for settings
- **Overlay:** AppKit NSPanel for floating always-on-top water drop
- **Charts:** Swift Charts for weekly bar charts
- **Tests:** Swift Testing framework (requires Xcode 16 / full Xcode — not just Command Line Tools)
- **Build:** Swift Package Manager + build.sh for .app bundle

## Build & Run
```bash
bash build.sh
open .build/release/Sipster.app
```

## Run Tests
```bash
swift test          # requires Xcode 16+
swift test --parallel
```

## Project Structure
```
Sources/
  Sipster/                          # Executable target
    SipsterApp.swift                # @main entry - MenuBarExtra + Window + Settings scenes
  SipsterLib/                       # Library target (all app logic, importable by tests)
    Models/
      DrinkLog.swift                # Codable struct - drink event (timestamp, amount, source)
      DrinkSize.swift               # Enum: Glass(150ml) / Cup(250ml) / Bottle(500ml)
      DayRecord.swift               # Computed daily aggregation struct
      UserSettings.swift            # @AppStorage-backed settings (ObservableObject)
    Services/
      DataStore.swift               # JSON persistence to ~/Library/Application Support/Sipster/
      ReminderManager.swift         # Timer scheduling, overlay presentation, drink logging
      SoundManager.swift            # NSSound wrapper
      LaunchAtLoginManager.swift    # SMAppService wrapper
    Views/
      MenuBar/MenuBarView.swift     # Menu bar popover (quick-add, progress, settings link)
      MenuBar/MenuBarIconView.swift # Custom Canvas water-drop icon with fill level
      Dashboard/DashboardView.swift # Compact 3-column layout: ring | stats | drinks + chart
      Dashboard/ProgressRingView.swift
      Dashboard/DrinkListView.swift
      Dashboard/WeeklyChartView.swift
      Dashboard/WeeklyStatsView.swift
      Preferences/PreferencesView.swift  # 3-tab: General, Schedule, About
      Overlay/FloatingDropWindow.swift   # NSPanel subclass
      Overlay/FloatingDropView.swift     # SwiftUI overlay with countdown ring
    Utilities/
      Constants.swift
      DateExtensions.swift
      NotificationHelper.swift

Tests/SipsterTests/
  DrinkLogTests.swift
  DateExtensionsTests.swift
  DrinkLogArrayTests.swift
  DataStoreTests.swift
  UserSettingsTests.swift

.github/workflows/
  ci.yml            # Build + test on push/PR (macos-15 runner)
  release.yml       # Build .app + publish GitHub Release on vX.Y.Z tag
```

## Key Architecture Decisions
- **LSUIElement=true**: Menu bar only, no dock icon
- **NSPanel** with `.borderless, .nonactivatingPanel` for floating overlay (doesn't steal focus)
- **Timer-based reminders**: Single timer fires at next calculated time, then recalculates
- **JSON persistence**: SwiftData macros incompatible with SPM command-line → `Codable` + JSON file
- **Library/executable split**: `SipsterLib` is a library target so tests can import it; all types `public`
- **AppStorage for settings**: Zero-boilerplate UserDefaults binding
- **SettingsLink**: macOS 14+ API used to open Settings scene from menu bar (replaces broken `NSApp.sendAction`)
- **No external dependencies**: All Apple system frameworks

## App Scenes
1. **MenuBarExtra** (.window style) - Primary interface, always in menu bar; icon uses `MenuBarIconView` with dynamic fill level
2. **Window** (id: "dashboard") - Compact dashboard (680×480), opened on demand
3. **Settings** - macOS preferences panel (Cmd+,), opened via `SettingsLink`

## Data Storage
- Drink logs: `~/Library/Application Support/Sipster/drinks.json`
- Settings: `UserDefaults` via `@AppStorage` (`com.sipster.app` domain)

## Release Process
```bash
git tag v1.1.0
git push origin v1.1.0
# → GitHub Actions builds .app, zips it, publishes Release automatically
```
