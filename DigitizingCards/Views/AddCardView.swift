//
//  AddCardView.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-14.
//

import SwiftUI
import SwiftData
 
struct AddCardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query(sort: \CardCategory.title) private var categories: [CardCategory]
    @Query(sort: \ScannedCard.userOrder) private var allCards: [ScannedCard]
    
    @State private var cardName = ""
    @State private var isShowingScanner = false
    
    @State private var scannedValue: String = ""
    @State private var scannedFormat: BarcodeFormat? = nil
    @State private var scanError: String? = nil
    
    @State private var manualBarcodeNumber = ""
    @State private var selectedFormat: BarcodeFormat = .code128
    
    @State private var selectedCategory: CardCategory?
    
    @State private var isShowingNewCategoryAlert = false
    @State private var newCategoryTitle = ""
    
    @State private var isShowingValidationError = false
    @State private var validationErrorMessage = ""
    
    var body: some View {
            NavigationStack {
                Form {
                    Section("Card Details") {
                        TextField("Card Name (e.g. Vancouver Public Library)", text: $cardName)
                        
                        HStack {
                            TextField("Account Number", text: $manualBarcodeNumber)
                                .onChange(of: scannedValue) { _, newValue in
                                    guard !newValue.isEmpty else { return }
                                    manualBarcodeNumber = newValue
                                    if let fmt = scannedFormat {
                                        selectedFormat = fmt
                                    }
                                }
                            
                            Button {
                                isShowingScanner = true
                            } label: {
                                Image(systemName: "barcode.viewfinder")
                                    .foregroundStyle(.blue)
                            }
                        }
                        Picker("Barcode Format", selection: $selectedFormat) {
                            ForEach([
                                BarcodeFormat.code128, .code39, .code93,
                                .qr, .aztec, .dataMatrix, .pdf417,
                                .ean13, .ean8, .upce, .itf14
                            ], id: \.self) { format in
                                Text(format.displayName).tag(format)
                            }
                        }
                    }
                    
                    Section("Categorization") {
                        Picker("Category", selection: $selectedCategory) {
                            Text("No Category").tag(nil as CardCategory?)
                            ForEach(categories) { category in
                                HStack {
                                    Circle()
                                        .fill(Color(hex: category.colorHex))
                                        .frame(width: 10, height: 10)
                                    Text(category.title)
                                }
                                .tag(category as CardCategory?)
                            }
                        }
                        Button(action: { isShowingNewCategoryAlert = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Create Custom Category")
                            }
                        }
                    }
                }
                .navigationTitle("Add New Card")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveCard()
                        }
                        .disabled(cardName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                  manualBarcodeNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
                .sheet(isPresented: $isShowingScanner) {
                    ScannerSheetView(
                        scannedValue: $scannedValue,
                        scannedFormat: $scannedFormat,
                        scanError: $scanError
                    )
                }
                .alert("Scan Failed", isPresented: Binding(
                    get: { scanError != nil },
                    set: { if !$0 { scanError = nil } }
                )) {
                    Button("OK", role: .cancel) { scanError = nil }
                } message: {
                    Text(scanError ?? "")
                }
                .alert("New Category", isPresented: $isShowingNewCategoryAlert) {
                    TextField("Category Name", text: $newCategoryTitle)
                    Button("Cancel", role: .cancel) { newCategoryTitle = "" }
                    Button("Create") {
                        if !newCategoryTitle.trimmingCharacters(in: .whitespaces).isEmpty {
                            let randomColors = ["#FF3B30", "#AF52DE", "#34C759", "#007AFF", "#FFCC00", "#5AC8FA"]
                            let maxOrder = categories.map{ $0.userOrder }.max() ?? -1
                            let newCat = CardCategory(
                                title: newCategoryTitle,
                                isSystem: false,
                                colorHex: randomColors.randomElement() ?? "#007AFF",
                                userOrder: maxOrder + 1
                            )
                            modelContext.insert(newCat)
                            selectedCategory = newCat
                            newCategoryTitle = ""
                        }
                    }
                } message: {
                    Text("Enter a title for your custom category layout.")
                }
                .alert("Cannot Save Card", isPresented: $isShowingValidationError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(validationErrorMessage)
                }
            }
        }
    
    
    private func saveCard() {
        let cleanedName = cardName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let cleanedBarcode = manualBarcodeNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if cleanedName.isEmpty {
            validationErrorMessage = "Please enter a name for this card."
            isShowingValidationError = true
            return
        }
        
        if cleanedBarcode.isEmpty {
            validationErrorMessage = "Please enter or scan a barcode number."
            isShowingValidationError = true
            return
        }
        
        let maxOrder = allCards.map { $0.userOrder }.max() ?? -1
        guard let barcodeModel = BarcodeData(value: cleanedBarcode, format: selectedFormat)
        else {
            validationErrorMessage =
                "The barcode is invalid for the selected format."
            isShowingValidationError = true
            return
        }
        
        
        let newCard = ScannedCard(
            title: cardName,
            category: selectedCategory,
            barcode: barcodeModel,
            userOrder: maxOrder + 1
        )
        
        modelContext.insert(newCard)
        dismiss()
    }
}

private struct ScannerSheetView: View {
    @Binding var scannedValue: String
    @Binding var scannedFormat: BarcodeFormat?
    @Binding var scanError: String?
 
    @State private var result: BarcodeData? = nil
    @State private var error: String? = nil
 
    var body: some View {
        BarcodeScannerView(scannedResult: $result, scanError: $error)
            .ignoresSafeArea()
            .overlay(alignment: .top) {
                Text("Tap the barcode on screen to scan")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .padding()
            }
            .onChange(of: result) { _, newValue in
                if let newValue {
                    scannedValue = newValue.value
                    scannedFormat = newValue.format
                }
            }
            .onChange(of: error) { _, newValue in
                scanError = newValue
            }
    }
}
 
enum BarcodeValidator {
    static func validate(
        _ value: String,
        format: BarcodeFormat
    ) -> Bool {
 
        switch format {
 
        case .ean13:
            return value.count == 13 &&
                   value.allSatisfy(\.isNumber)
 
        case .ean8:
            return value.count == 8 &&
                   value.allSatisfy(\.isNumber)
 
        case .upce:
            return value.count == 8 &&
                   value.allSatisfy(\.isNumber)
 
        case .itf14:
            return value.count == 14 &&
                   value.allSatisfy(\.isNumber)
 
        default:
            return !value.isEmpty
        }
    }
}
