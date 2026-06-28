//
//  IOSAssignment6App.swift
//  IOSAssignment6
//
//  Created by Kyle Burk on 2026-06-25.
//

import SwiftUI

@main
struct IOSAssignment6App: App {
    @StateObject private var settings = SettingsStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
