//
//  CategoryManagementView.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-16.
//

import SwiftUI
import SwiftData

struct CategoryManagementView: View {
    @Query(sort: \CardCategory.title) private var categories: [CardCategory]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var categoryToEdit: CardCategory?
    @State private var isShowingForm = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { category in
                    HStack {
                        Circle()
                            .fill(Color(hex: category.colorHex))
                            .frame(width: 12, height: 12)
                        
                        Text(category.title)
                            .font(.body)
                        
                        Spacer()
                        
                        if category.isSystem {
                            Text("Default")
                                .font(.caption2)
                                .bold()
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(.systemGray5))
                                .cornerRadius(4)
                        }
                    }
                    .onTapGesture {
                        categoryToEdit = category
                        isShowingForm = true
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        if !category.isSystem {
                            Button(role: .destructive) {
                                modelContext.delete(category)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                categoryToEdit = category
                                isShowingForm = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle("Manage Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        categoryToEdit = nil
                        isShowingForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $isShowingForm) {
                CategoryFormView(categoryToEdit: categoryToEdit)
            }
        }
    }
}
