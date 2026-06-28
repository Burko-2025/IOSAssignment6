//
//  BurgerView.swift
//  IOSAssignment6
//
//  Created by Kyle Burk on 2026-06-26.
//

import SwiftUI

// Displays a single burger builder.
//
// Each card contains:
// - A burger picker
// - Condiment toggles
//
// Because Burger is passed as a Binding,
// every card edits its own burger independently.
struct BurgerCardView: View {

    // The burger being edited.
    @Binding var burger: Burger
    // MARK: - Settings
    
    @StateObject private var settings = SettingsStore()
    
    @State private var showingSettings = false
    // The available burger types.
    let burgers: [String]

    var body: some View {

        VStack(alignment: .leading, spacing: 15) {

            // Burger selection
            Text("Choose Your Burger")
                .font(.system(size: settings.fontSize))


            Picker(
                "Burger",
                selection: $burger.burgerType
            ) {

                ForEach(
                    0..<burgers.count,
                    id: \.self
                ) { index in

                    Text(burgers[index])
                        .tag(index)
                        .font(
                            .system(
                                size: settings.fontSize
                            )
)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)

            Divider()

            // Condiments section

            Text("Choose Your Condiments")
                    .font(
                        .system(
                            size: settings.fontSize
                        )
)

            Toggle(
                "Ketchup",
                isOn: $burger.ketchup
            )
            .font(
                .system(
                    size: settings.fontSize
                )
            )

            Toggle(
                "Mustard",
                isOn: $burger.mustard
            )
            .font(
                .system(
                    size: settings.fontSize
                )
            )
            

            Toggle(
                "Pickles",
                isOn: $burger.pickles
            )
            .font(
                .system(
                    size: settings.fontSize
                )
            )

            Toggle(
                "Onions",
                isOn: $burger.onions
            )
            .font(
                .system(
                    size: settings.fontSize
                )
            )

            Toggle(
                "Mayo",
                isOn: $burger.mayo
            )
            .font(
                .system(
                    size: settings.fontSize
                )
            )

            Toggle(
                "Lettuce",
                isOn: $burger.lettuce
            )
            .font(
                .system(
                    size: settings.fontSize
                )
            )

            Toggle(
                "Tomato",
                isOn: $burger.tomato
            )
            .font(
                .system(
                    size: settings.fontSize
                )
            )
        }

        .padding()

        .background(Color(.systemBackground))

        .cornerRadius(20)

        .shadow(
            color: .gray.opacity(0.2),
            radius: 6
        )
    }
}

#Preview {

    BurgerCardView(

        burger: .constant(Burger()),

        burgers: [

            "Classic",

            "Cheeseburger",

            "Bacon Burger",

            "Chicken Burger"
        ]
    )
    .padding()
}
