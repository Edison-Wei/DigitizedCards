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
    @State private var barcodeNumber = ""
    @State private var isShowingScanner = false
    @State private var barcodeFormat = ""
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
                            TextField("Account Number", text: $barcodeNumber)
                            
                            Button {
                                isShowingScanner = true
                            } label: {
                                Image(systemName: "barcode.viewfinder")
                                    .foregroundStyle(.blue)
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
                        .disabled(cardName.isEmpty || barcodeNumber.isEmpty)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
                .sheet(isPresented: $isShowingScanner) {
                    BarcodeScannerView(scannedCode: $barcodeNumber)
                        .ignoresSafeArea()
                        .overlay(alignment: .top) {
                            Text("Tap the barcode on screen to scan")
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                .padding()
                        }
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
                                userOrder: maxOrder
                            )
                            modelContext.insert(newCat)
                            selectedCategory = newCat // Auto-select the newly created category
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
        let cleanedBarcode = barcodeNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedName.isEmpty {
            validationErrorMessage = "Please enter a name for this card."
            isShowingValidationError = true
        }
        
        if cleanedBarcode.isEmpty {
            validationErrorMessage = "Please enter or scan a barcode number."
            isShowingValidationError = true
        }
        
        let maxOrder = allCards.map { $0.userOrder }.max() ?? -1
        
        
        let newCard = ScannedCard(
            title: cardName,
            category: selectedCategory,
            barcodeNumber: barcodeNumber,
            barcodeFormat: "Code128",
            userOrder: maxOrder + 1
        )
        
        modelContext.insert(newCard)
        dismiss()
    }
}
