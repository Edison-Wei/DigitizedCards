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
    @State private var selectedColor: Color
 
    let colors = ["#FF3B30", "#FF2D55", "#FFEAEC", "#C84C09", "#FF9500", "#FFCC00", "#F3DE8A", "#9EE493", "#4CD964",
                  "#3F6C51", "#388697", "#5AC8FA", "#007AFF", "#5856D6", "#42273B", "#7E7F9A", "#97A7B3", "#8E8E93"]
    
    init(categoryToEdit: CardCategory? = nil) {
        self.categoryToEdit = categoryToEdit
        let initialHex = categoryToEdit?.colorHex ?? "#FF3B30"
        _selectedColor = State(initialValue: Color(hex: initialHex))
    }
    
    var body: some View {
        NavigationStack {
            Form{
                Section("Category Info") {
                    TextField("Category Name", text: $title)
                }
                
                Section("Color Theme") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 45))], spacing: 12) {
                        ForEach(colors, id: \.self) { hex in
                            presentColours(hex: Color(hex: hex))
                        }
                    }
                    .padding(.vertical, 4)
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
                }
            }
        }
    }
    
    private func save() {
        let hexString: String = selectedColor.toHex() ?? "#007AFF"
        
        if let category = categoryToEdit {
            category.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            category.colorHex = hexString
        } else {
            let newCategory = CardCategory(title: title.trimmingCharacters(in: .whitespacesAndNewlines), isSystem: false, colorHex: hexString)
            modelContext.insert(newCategory)
        }
        dismiss()
    }
    
    private func presentColours(hex: Color) -> some View {
        Circle()
            .fill(hex)
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
