//
//  SettingsPopOverView.swift
//  IOSAssignment6
//
//  Created by Kyle Burk on 2026-06-25.
//

import SwiftUI

// Popover view used to display and modify app settings.
struct SettingsPopoverView: View {

    // Shared settings object used throughout the app.
    @EnvironmentObject var settings: SettingsStore

    // Controls whether the popover is currently displayed.
    // Passed in from the parent view.
    @Binding var isPresented: Bool

    var body: some View {

        // NavigationStack provides a navigation bar
        // and toolbar for the settings popover.
        NavigationStack {

            // Form automatically groups settings into sections
            // and provides a native settings-style appearance.
            Form {

                // MARK: - Appearance Settings

                Section(header: Text("Appearance")) {

                    // Theme picker allowing the user to choose
                    // between Automatic, Light, and Dark modes.
                    Picker("Theme", selection: $settings.theme) {

                        // Create a picker option for every theme
                        ForEach(SettingsStore.Theme.allCases) { t in
                            Text(t.rawValue)
                                .tag(t)
                        }
                    }

                    // Display the picker as a segmented control
                    .pickerStyle(.segmented)
                }

                // MARK: - Content Settings

                Section(header: Text("Content")) {

                    // Controls whether the decorative grid
                    // is shown in the detail view.

                    // Font size controls
                    HStack {

                        Text("Font size")

                        // Slider updates the font size value
                        // between 12 and 30 points.
                        Slider(
                            value: $settings.fontSize,
                            in: 12...30,
                            step: 1
                        )

                        // Displays the current font size
                        // selected by the slider.
                        Text("\(Int(settings.fontSize))")
                            .frame(
                                minWidth: 36,
                                alignment: .trailing
                            )
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // Title displayed in the navigation bar
            .navigationTitle("Settings")

            // Toolbar items shown in the navigation bar
            .toolbar {

                // Confirmation button placed on the trailing side
                ToolbarItem(placement: .confirmationAction) {

                    Button("Done") {

                        // Close the popover
                        isPresented = false
                    }

                    // Allows Return/Enter to activate this button
                    .keyboardShortcut(.defaultAction)
                }
            }
        }

        // Allows the popover to be dismissed by tapping outside
        // on supported devices such as iPad.
        .interactiveDismissDisabled(false)
    }
}

// MARK: - Preview

#Preview {

    SettingsPopoverView(
        isPresented: .constant(true)
    )

    // Inject a sample settings object for previews
    .environmentObject(SettingsStore())
}
