//
//  LibraryCard.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-14.
//

import Foundation
import SwiftData

@Model
class LibraryCard {
    var id: UUID
    var title: String
    var barcodeNumber: String
    var barcodeFormat: String
    var notes: String?
    var dateAdded: Date
    var category: CardCategory?
    
    init(title: String, barcodeNumber: String, barcodeFormat: String) {
        self.id = UUID()
        self.title = title
        self.barcodeNumber = barcodeNumber
        self.barcodeFormat = barcodeFormat
        self.dateAdded = .now
    }
}
