//
//  Category.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-16.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class CardCategory {
    var title: String
    var isSystem: Bool
    var colorHex: String
    var userOrder: Int
    
    var identifier: String
    
    @Relationship(deleteRule: .nullify, inverse: \ScannedCard.category)
    var cards: [ScannedCard]?
    
    init(title: String, isSystem: Bool = false, colorHex: String = "#007AFF", userOrder: Int = 0) {
        self.title = title
        self.isSystem = isSystem
        self.colorHex = colorHex
        self.cards = []
        self.userOrder = userOrder
        self.identifier = UUID().uuidString
    }
    
    var isEmpty: Bool {
        cards?.isEmpty ?? true
    }
}
