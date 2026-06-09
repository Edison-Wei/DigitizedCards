//
//  LibraryCard.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-14.
//

import Foundation
import SwiftData

@Model
class ScannedCard {
    var id: UUID
    var title: String
    var notes: String?
    var dateAdded: Date
    var userOrder: Int
    
    @Relationship(deleteRule: .cascade)
    var barcode: BarcodeData
    
    @Relationship
    var category: CardCategory?
    
    init(title: String, category: CardCategory? = nil, barcode: BarcodeData, userOrder: Int = 0) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.barcode = barcode
        self.dateAdded = .now
        self.userOrder = userOrder
    }
}
