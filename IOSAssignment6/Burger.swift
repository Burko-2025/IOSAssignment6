//
//  Burger.swift
//  IOSAssignment6
//
//  Created by Kyle Burk on 2026-06-26.
//

import Foundation

// Represents a single burger in the customer's order.
//
// Every burger stores:
// - The selected burger type
// - Which condiments have been selected
//
// Because the app displays a variable number of burgers,
// each burger needs its own independent state.
struct Burger: Identifiable {
    let id = UUID()

    var burgerType: Int = 0

    var ketchup = false
    var mustard = false
    var pickles = false
    var onions = false
    var mayo = false
    var lettuce = false
    var tomato = false



    // Returns all selected condiments as an array.
    //
    // This makes building the order summary much easier.
    var selectedCondiments: [String] {

        var condiments: [String] = []

        if ketchup {
            condiments.append("Ketchup")
        }

        if mustard {
            condiments.append("Mustard")
        }

        if pickles {
            condiments.append("Pickles")
        }

        if onions {
            condiments.append("Onions")
        }

        if mayo {
            condiments.append("Mayo")
        }

        if lettuce {
            condiments.append("Lettuce")
        }

        if tomato {
            condiments.append("Tomato")
        }

        return condiments
    }
}
