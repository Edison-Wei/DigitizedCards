//
//  BardcodeService.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-14.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct BardcodeGenerator {
    let context = CIContext()
    let filter = CIFilter.code128BarcodeGenerator()
    
    func generate(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            let transformed = outputImage.transformed(by: CGAffineTransform(scaleX: 3, y: 3))
            if let cgImage = context.createCGImage(transformed, from: transformed.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}
