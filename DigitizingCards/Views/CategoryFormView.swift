//
//  CategoryFromView.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-16.
//

import SwiftUI
import SwiftData

struct CategoryFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var categoryToEdit: CardCategory?
    
    @State private var title = ""
    @State private var selectedColor: Color = .blue
    
    let colors = ["#FF3B30", "#FF9500", "#FFCC00", "#4CD964", "#5AC8FA", "#007AFF", "#5856D6", "#FF2D55", "#8E8E93"]
    
    var body: some View {
        NavigationStack {
            Form{
                Section("Category Info") {
                    TextField("Category Name", text: $title)
                }
                
                Section("Color Theme") {
                    ColorPicker("Pick a Colour", selection: $selectedColor)
                }
            }
            .navigationTitle(categoryToEdit == nil ? "New Category" : "Edit Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let category = categoryToEdit {
                    title = category.title
                    selectedColor = Color(hex: category.colorHex)
                }
            }
        }
    }
    
    private func save() {
        let hexString: String = selectedColor.toHex() ?? "#007AFF"
        
        if let category = categoryToEdit {
            category.title = title
            category.colorHex = hexString
        } else {
            let newCategory = CardCategory(title: title, isSystem: false, colorHex: hexString)
            modelContext.insert(newCategory)
        }
        dismiss()
    }
}
