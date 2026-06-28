//
//  SettingsStore.swift
//  IOSAssignment6
//
//  Created by Kyle Burk on 2026-06-25.
//

import Foundation
import SwiftUI

// Stores the user's app settings.
//
// This class uses @AppStorage so the settings
// are automatically saved and restored every
// time the app launches.
final class SettingsStore: ObservableObject {

    // MARK: - Theme Setting

    // Stores the selected theme as a String
    // inside UserDefaults.
    @AppStorage("theme")
    var themeRaw: String = Theme.automatic.rawValue {
        didSet {
            // Notify SwiftUI whenever the theme changes.
            objectWillChange.send()
        }
    }

    // MARK: - Font Size Setting

    // Stores the preferred font size.
    // The value is saved automatically.
    @AppStorage("fontSize")
    var fontSize: Double = 18.0 {
        didSet {
            // Refresh any views using this setting.
            objectWillChange.send()
        }
    }

    // MARK: - Theme Conversion

    // Converts the stored String into the Theme enum
    // so the rest of the app can work with strongly
    // typed values instead of raw strings.
    var theme: Theme {
        get {
            Theme(rawValue: themeRaw) ?? .automatic
        }
        set {
            themeRaw = newValue.rawValue
        }
    }

    // MARK: - Theme Options

    // Available appearance options for the app.
    enum Theme: String, CaseIterable, Identifiable {

        // Follow the device's appearance.
        case automatic = "Automatic"

        // Always use light mode.
        case light = "Light"

        // Always use dark mode.
        case dark = "Dark"

        // Allows SwiftUI to uniquely identify each theme.
        var id: String {
            rawValue
        }
    }
}

