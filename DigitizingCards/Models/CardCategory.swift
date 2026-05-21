//
//  Category.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-16.
//

import Foundation
import SwiftData

@Model
class Category {
    var id: UUID
    var title: String
    var isSystem: Bool
    var colorHex: String
    
    init(title: String, isSystem: Bool = false, colorHex: String = "#007AFF") {
        self.id = UUID()
        self.title = title
        self.isSystem = isSystem
        self.colorHex = colorHex
    }
}
