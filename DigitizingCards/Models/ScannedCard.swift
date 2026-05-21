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
    var barcodeNumber: String
    var barcodeFormat: String
    var notes: String?
    var dateAdded: Date
    var category: CardCategory?
    var userOrder: Int
    
    init(title: String, category: CardCategory? = nil, barcodeNumber: String, barcodeFormat: String, userOrder: Int = 0) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.barcodeNumber = barcodeNumber
        self.barcodeFormat = barcodeFormat
        self.dateAdded = .now
        self.userOrder = userOrder
    }
}
