//
//  CategoryFromView.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-16.
//

import SwiftUI
import SwiftData

struct CategoryFromView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var categoryToEdit: CardCategory?
    
    @State private var title = ""
    @State private var selectedColor = "#007AFF"
    
    let colors = ["#FF3B30", "#FF9500", "#FFCC00", "#4CD964", "#5AC8FA", "#007AFF", "#5856D6", "#FF2D55", "#8E8E93"]
    
    var body: some View {
        NavigationStack {
            Form{
                Section("Category Info") {
                    TextField("Category Name", text $title)
                }
                
                Section("Color Theme") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 45))], spacing: 12) {
                        ForEach(colors, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: selectedColor == hex ? 3 : 0)
                                )
                                .onTapGesture {
                                    selectedColor = hex
                                }
                        }
                    }
                    .padding(.vertical, 4)
                }
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
            .onAppear {
                if let category = categoryToEdit {
                    title = category.title
                    selectedColor = category.colorHex
                }
            }
        }
    }
    
    private func save() {
        if let category = categoryToEdit {
            category.title = title
            category.colorHex = selectedColor
        } else {
            let newCategory = CardCategory(title: title, isSystem: false, colorHex: selectedColor)
            modelContext.insert(newCategory)
        }
        dismiss()
    }
}
