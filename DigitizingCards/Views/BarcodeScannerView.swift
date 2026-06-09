//
//  BarcodeScannerView.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-14.
//

import SwiftUI
import VisionKit
import Vision
 
struct BarcodeScannerView: UIViewControllerRepresentable {
    @Binding var scannedResult: BarcodeData?
    @Binding var scanError: String?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .balanced,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        try? scanner.startScanning()
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: BarcodeScannerView
        
        init(parent: BarcodeScannerView) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            guard case .barcode(let barcode) = item,
                let value = barcode.payloadStringValue,
                let format = mapBarcodeSymbology(barcode.observation.symbology)
            else {
                return
            }
            
            MainActor.assumeIsolated {
                if let barcodeData = BarcodeData(value: value, format: format) {
                    parent.scannedResult = barcodeData
                    parent.dismiss()
                } else {
                    parent.scanError = "The scanned barcode (\(format.rawValue.uppercased())) has an unexpected format. Try scanning again or enter the number manually."
                    parent.dismiss()
                }
            }
        }
        
        private func mapBarcodeSymbology(_ symbology: VNBarcodeSymbology) -> BarcodeFormat? {
            switch symbology {
 
            case .qr:
                return .qr
 
            case .aztec:
                return .aztec
 
            case .dataMatrix:
                return .dataMatrix
 
            case .pdf417:
                return .pdf417
 
            case .code128:
                return .code128
 
            case .code39:
                return .code39
 
            case .code93:
                return .code93
 
            case .ean8:
                return .ean8
 
            case .ean13:
                return .ean13
 
            case .upce:
                return .upce
 
            case .i2of5, .itf14:
                return .itf14
 
            default:
                return nil
            }
        }
    }
}
