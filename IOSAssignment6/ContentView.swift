//
//  ContentView.swift
//  IOSAssignment6
//
//  Created by Kyle Burk on 2026-06-25.
//


import SwiftUI
import UserNotifications

struct ContentView: View {

    // MARK: - Pickup Date & Time
    // Stores the date and time selected by the user
    // for when they want to pick up their order.
    @State private var selectedDate = Date()

    // MARK: - Settings
    // Stores the user's app settings such as
    // theme and font size.
    @StateObject private var settings = SettingsStore()

    // Controls whether the settings popover
    // is currently being displayed.
    @State private var showingSettings = false

    // MARK: - Burger Order
    // Stores every burger in the customer's order.
    // Each Burger has its own type and condiments.
    @State private var burgersOrdered: [Burger] = [Burger()]

    // Creates a Binding between the slider and
    // the number of burgers in the order.
    //
    // Moving the slider automatically adds or
    // removes Burger objects from the array.
    private var burgerTotal: Binding<Double> {
        Binding(
            get: {
                Double(burgersOrdered.count)
            },
            set: { newValue in

                let total = Int(newValue)

                // Add burgers if the slider increased.
                if total > burgersOrdered.count {

                    burgersOrdered.append(
                        contentsOf: Array(
                            repeating: Burger(),
                            count: total - burgersOrdered.count
                        )
                    )

                // Remove burgers if the slider decreased.
                } else if total < burgersOrdered.count {

                    burgersOrdered = Array(
                        burgersOrdered.prefix(total)
                    )
                }
            }
        )
    }

    // MARK: - Order Alert
    // Controls whether the order confirmation
    // alert is visible.
    @State private var showingAlert = false

    // Stores the completed order summary
    // shown inside the alert.
    @State private var orderSummary = ""

    // MARK: - Available Burger Types
    // Every burger can choose one of these.
    private let burgers = [
        "Classic",
        "Cheeseburger",
        "Bacon Burger",
        "Chicken Burger"
    ]

    // MARK: - Date Formatter
    // Converts the selected pickup date into
    // a readable string.
    private var formattedDate: String {

        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short

        return formatter.string(from: selectedDate)
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 25) {

                    // MARK: - Burger Quantity Card
                    CardView(title: "Number of Burgers") {

                        // Slider that controls how many
                        // burgers are in the order.
                        Slider(
                            value: burgerTotal,
                            in: 1...10,
                            step: 1
                        )
                        .tint(.purple)

                        // Display the current number
                        // of burgers selected.
                        let burgerCount = Int(burgerTotal.wrappedValue)

                        Text("\(burgerCount) Burger\(burgerCount == 1 ? "" : "s")")
                            .font(.system(size: settings.fontSize))
                            .foregroundStyle(.purple)
                    }

                    // MARK: - Burger Cards
                    // Creates one BurgerCardView
                    // for every burger in the order.
                    ForEach($burgersOrdered) { $burger in

                        CardView(title: "Burger") {

                            BurgerCardView(
                                burger: $burger,
                                burgers: burgers
                            )
                        }
                    }

                    // MARK: - Pickup Time Card
                    CardView(title: "Pickup Time") {

                        DatePicker(
                            "Select Pickup Time",
                            selection: $selectedDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                    }

                    // MARK: - Place Order Button
                    // Generates the order summary
                    // and schedules a notification.
                    Button {

                        placeOrder()

                    } label: {

                        Label("Place Order", systemImage: "cart.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)

                }
                .padding()
            }

            .navigationTitle("Burger Barn")

            // MARK: - Toolbar
            // Displays the settings button
            // in the top-right corner.
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button {

                        showingSettings = true

                    } label: {

                        Image(systemName: "gearshape.fill")
                    }
                }
            }

            // MARK: - Settings Popover
            .popover(isPresented: $showingSettings) {

                SettingsPopoverView(isPresented: $showingSettings)
                    .environmentObject(settings)
            }

            // MARK: - Order Confirmation Alert
            .alert("Order Placed", isPresented: $showingAlert) {

                Button("OK") {

                    // Eventually this will reset
                    // the order back to one burger.
                    // burgersOrdered = [Burger()]

                    selectedDate = Date()
                    orderSummary = ""
                    showingAlert = false
                }

            } message: {

                Text(orderSummary)
            }

            // Ask for notification permission
            // when the app first appears.
            .onAppear {

                requestNotificationPermission()
            }
        }

        // Applies the user's selected theme.
        .preferredColorScheme(
            colorScheme(for: settings.theme)
        )
    }

    // MARK: - Place Order
    // Builds the order summary,
    // schedules the pickup notification,
    // and displays the confirmation alert.
    private func placeOrder() {

        var summary = ""

        for (index, burger) in burgersOrdered.enumerated() {

            summary += "Burger \(index + 1)\n"
            summary += "\(burgers[burger.burgerType])\n"

            if burger.selectedCondiments.isEmpty {

                summary += "No condiments"

            } else {

                summary += burger.selectedCondiments.joined(separator: ", ")
            }

            summary += "\n\n"
        }

        summary += "Pickup Time:\n"
        summary += formattedDate

        orderSummary = summary

        scheduleNotification()

        showingAlert = true
    }

    // MARK: - Schedule Notification
    // Creates a local notification
    // for the selected pickup time.
    private func scheduleNotification() {

        let content = UNMutableNotificationContent()

        content.title = "🍔 Burger Barn"
        content.body = "Your order is ready for pickup!"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: selectedDate
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerDate,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Notification Permission
    // Requests permission to send
    // local notifications.
    private func requestNotificationPermission() {

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { _, _ in }
    }
    // MARK: - App Theme

    // Returns the appropriate color scheme based on the user's
    // selected theme in the settings screen.
    //
    // - Automatic: Uses the system appearance.
    // - Light: Forces light mode.
    // - Dark: Forces dark mode.
    private func colorScheme(for theme: SettingsStore.Theme) -> ColorScheme? {
        switch theme {
        case .automatic:
            return nil

        case .light:
            return .light

        case .dark:
            return .dark
        }
    }

    // MARK: - Burger Binding

    // Finds the matching burger inside the burgersOrdered array
    // and returns a Binding so SwiftUI can edit it.
    //
    // This helper is useful when a view needs a Binding<Burger>
    // instead of the Burger value itself.
    //
    // The app will crash if the burger cannot be found because
    // that indicates a programming error.
    private func binding(for burger: Burger) -> Binding<Burger> {
        guard let index = burgersOrdered.firstIndex(where: { $0.id == burger.id }) else {
            fatalError("Burger not found")
        }

        return $burgersOrdered[index]
    }
}

// MARK: - Card View Component

// A reusable card used throughout the app.
//
// It displays a title at the top and any SwiftUI view
// passed into the content closure underneath.
struct CardView<Content: View>: View {

    // Title displayed at the top of the card.
    let title: String

    // The content placed inside the card.
    let content: Content

    // Initializes a card with a title and custom content.
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 15) {

            // Card heading
            Text(title)
                .font(.title3)
                .bold()
                .padding(.bottom, 5)

            // Custom content supplied by the caller.
            content
        }
        .padding()

        // Makes every card stretch across the screen.
        .frame(maxWidth: .infinity, alignment: .leading)

        // Gives the card a background that adapts
        // to light and dark mode.
        .background(Color(.systemBackground))

        // Rounded corners.
        .cornerRadius(16)

        // Soft drop shadow.
        .shadow(
            color: .gray.opacity(0.15),
            radius: 8,
            x: 0,
            y: 3
        )
    }
}

// MARK: - Preview

// Displays the ContentView in Xcode's preview canvas.
#Preview {
    ContentView()
}
