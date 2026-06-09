//
//  PreviewContainer.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-20.
//

import SwiftData
import SwiftUI

@MainActor
struct PreviewContainer {
    
    static let shared: ModelContainer = {
        do {
            let container = try ModelContainer(
                for: CardCategory.self,
                ScannedCard.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            
            let context = container.mainContext
            
            let category = CardCategory(title: "Rewards", isSystem: true, colorHex: "#FF9500", userOrder: 0)
            
            let card = ScannedCard(
                title: "Starbucks",
                category: category,
                barcode: BarcodeData(value: "1241414", format: BarcodeFormat.qr)!,
                userOrder: 0
            )
            
            context.insert(category)
            context.insert(card)

            let category_1 = CardCategory(title: "Other things", isSystem: false, colorHex: "#F595F0", userOrder: 1)
            
            let card_1 = ScannedCard(
                title: "Vancouver Public Library",
                category: category_1,
                barcode: BarcodeData(value: "123456789", format: BarcodeFormat.code128)!,
                userOrder: 1
            )
            
            context.insert(category_1)
            context.insert(card_1)
            
            return container
            
        } catch {
            fatalError("Failed to create preview container")
        }
    }()
}
