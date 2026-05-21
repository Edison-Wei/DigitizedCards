//
//  DigitizingCardsApp.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-13.
//

import SwiftUI
import SwiftData

@main
struct DigitizingCardsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: LibraryCard.self)
    }
}
