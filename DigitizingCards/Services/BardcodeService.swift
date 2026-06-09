//
//  BardcodeService.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-14.
//

import UIKit
import AVFoundation
import RSBarcodes_Swift
 
struct BarcodeGenerator {
    static let shared = BarcodeGenerator()
 
    private init() {}
 
    func generate(from value: String, format: BarcodeFormat) -> UIImage? {
        RSUnifiedCodeGenerator.shared.generateCode(
            value,
            machineReadableCodeObjectType: format.avObjectType
        )
    }
}
 
