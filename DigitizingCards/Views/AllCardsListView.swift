//
//  AllCardsListView.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-20.
//

import SwiftUI
import SwiftData
 
struct AllCardsListView: View {
    @Query(sort: \ScannedCard.userOrder) private var allCards: [ScannedCard]
    @Query(sort: \CardCategory.title) private var categories: [CardCategory]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText = ""
    
    @State private var showFilterBar: Bool = true
    @State private var selectedFilterCategory: CardCategory? = nil
    
    var canMoveCards: Bool {
        searchText.isEmpty && selectedFilterCategory == nil
    }
    
    var filteredCards: [ScannedCard] {
        allCards.filter { card in
            let matchesSearch = searchText.isEmpty ||
            card.title.localizedStandardContains(searchText) ||
            card.barcode.value.localizedStandardContains(searchText)
            
            let matchesCategory = !showFilterBar || selectedFilterCategory == nil ||
            card.category?.identifier == selectedFilterCategory?.identifier
            
            return matchesSearch && matchesCategory
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ToggleChip(title: "All Cards", isSelected: selectedFilterCategory == nil) {
                            selectedFilterCategory = nil
                        }
                        
                        ForEach(categories) { category in
                            ToggleChip(title: category.title, isSelected: selectedFilterCategory?.identifier == category.identifier, colorHex: category.colorHex) {
                                selectedFilterCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(.systemGroupedBackground))
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            List {
                ForEach(filteredCards) { card in
                    NavigationLink(destination: CardDetailView(card: card)) {
                        HStack {
                            Capsule()
                                .fill(Color(hex: card.category?.colorHex ?? "#8E8E93"))
                                .frame(width: 5, height: 35)
                                .padding(.trailing, 8)
                            
                            VStack(alignment: .leading) {
                                Text(card.title)
                                    .font(.headline)
                                HStack {
                                    if let categoryTitle = card.category?.title {
                                        Text(categoryTitle)
                                            .font(.caption)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color(hex: card.category?.colorHex ?? "#8E8E93").opacity(0.15))
                                            .foregroundStyle(Color(hex: card.category?.colorHex ?? "#8E8E93"))
                                            .cornerRadius(4)
                                    }
                                }
                                Text("Added on \(card.dateAdded.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "barcode")
                                .foregroundStyle(Color(hex: card.category?.colorHex ?? "#007AFF"))
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteCards)
                .onMove(perform: canMoveCards
                        ? { source, destination in
                    moveCards(from: source, to: destination)
                    }
                    : nil)
            }
            .navigationTitle("All Cards")
            .searchable(text: $searchText, prompt: "Search cards")
            .overlay {
                if filteredCards.isEmpty {
                    ContentUnavailableView(
                        searchText.isEmpty ? "No Cards" : "No Results",
                        systemImage: "magnifyingglass",
                        description: Text(searchText.isEmpty ? "Tap the + to digitize your first card." : "No cards found matching '\(searchText)'")
                    )
                }
            }
        }
    }
    
    private func moveCards(from source: IndexSet, to destination: Int) {
        var updatedList = allCards
        
        let sourceIndicesInAll = source.map { filteredIndex -> Int in
            let card = filteredCards[filteredIndex]
            return updatedList.firstIndex(where: { $0.id == card.id }) ?? filteredIndex
        }
        
        let destinationCard: ScannedCard?
        if destination < filteredCards.count {
            destinationCard = filteredCards[destination]
        } else {
            destinationCard = filteredCards.last
        }
        let destinationIndexInAll = destinationCard.flatMap { d in
            updatedList.firstIndex(where: { $0.id == d.id })
        } ?? updatedList.count
        
        updatedList.move(
            fromOffsets: IndexSet(sourceIndicesInAll),
            toOffset: destinationIndexInAll
        )
        
        for (index, card) in updatedList.enumerated() {
            card.userOrder = index
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save card order:", error)
        }
    }
    
    private func deleteCards(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredCards[index])
        }
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete card:", error)
        }
    }
}
 
struct ToggleChip: View {
    let title: String
    let isSelected: Bool
    var colorHex: String = "#007AFF"
    let action: () -> Void
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .bold(isSelected)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color(hex: colorHex) : Color(.systemGray5))
            .foregroundStyle(isSelected ? .white : .primary)
            .cornerRadius(20)
            .onTapGesture {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                    action()
                }
            }
    }
}
