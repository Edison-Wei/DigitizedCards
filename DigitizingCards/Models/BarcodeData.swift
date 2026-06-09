//
//  BarcodeData.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-06-01.
//

import Foundation
import SwiftData
import AVFoundation
 
enum BarcodeType: String, Codable {
    case oneDimensional
    case twoDimensional
}
 
enum BarcodeFormat: String, Codable {
    case qr
    case aztec
    case dataMatrix
    case pdf417
    case code128
    case code39
    case code93
    case ean8
    case ean13
    case upce
    case itf14
 
    var type: BarcodeType {
        switch self {
        case .qr, .aztec, .dataMatrix, .pdf417:
            return .twoDimensional
        default:
            return .oneDimensional
        }
    }
 
    var avObjectType: String {
        switch self {
        case .qr:        return AVMetadataObject.ObjectType.qr.rawValue
        case .aztec:     return AVMetadataObject.ObjectType.aztec.rawValue
        case .dataMatrix: return AVMetadataObject.ObjectType.dataMatrix.rawValue
        case .pdf417:    return AVMetadataObject.ObjectType.pdf417.rawValue
        case .code128:   return AVMetadataObject.ObjectType.code128.rawValue
        case .code39:    return AVMetadataObject.ObjectType.code39.rawValue
        case .code93:    return AVMetadataObject.ObjectType.code93.rawValue
        case .ean8:      return AVMetadataObject.ObjectType.ean8.rawValue
        case .ean13:     return AVMetadataObject.ObjectType.ean13.rawValue
        case .upce:      return AVMetadataObject.ObjectType.upce.rawValue
        case .itf14:     return AVMetadataObject.ObjectType.itf14.rawValue
        }
    }
 
    /// Human-readable label used in pickers and the detail view.
    var displayName: String {
        switch self {
        case .qr:         return "QR Code"
        case .aztec:      return "Aztec"
        case .dataMatrix: return "Data Matrix"
        case .pdf417:     return "PDF 417"
        case .code128:    return "Code 128"
        case .code39:     return "Code 39"
        case .code93:     return "Code 93"
        case .ean8:       return "EAN-8"
        case .ean13:      return "EAN-13"
        case .upce:       return "UPC-E"
        case .itf14:      return "ITF-14"
        }
    }
}
 
@Model
class BarcodeData {
    var value: String
    var formatRawValue: String
    
    var is2D: Bool {
        format.type == .twoDimensional
    }
 
    var format: BarcodeFormat {
        get { BarcodeFormat(rawValue: formatRawValue) ?? .code128 }
        set { formatRawValue = newValue.rawValue }
    }
 
    init?(value: String, format: BarcodeFormat) {
        guard BarcodeValidator.validate(value, format: format) else {
            return nil
        }
        
        self.value = value
        self.formatRawValue = format.rawValue
    }
}
