//
//  ContentView.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-13.
//

import SwiftUI
import SwiftData
import CoreTransferable

struct ContentView: View {
    @Query(sort: \ScannedCard.userOrder) private var cards: [ScannedCard]
    @Query(sort: \CardCategory.userOrder) private var categories: [CardCategory]
    @Environment(\.modelContext) private var modelContext
    
    @State private var isShowingAddCard = false
    @State private var isShowingManageCategories = false
    @State private var isShowingAllCardsList = false
    
    @State private var draggedCategory: CardCategory?
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [
                    Color.teal.opacity(0.2),
                    Color.gray.opacity(0.3),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: -40) {
                        ForEach(categories) { category in
                            categoryRow(category)
                        }
                        .onMove(perform: onMoveCategory)
                    }
                    .padding()
                    .padding(.top, 10)
                    .animation(.default, value: categories)
                }
                .navigationTitle("Digitized Cards")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button {
                            isShowingAllCardsList = true
                        } label: {
                            Image(systemName: "list.bullet.rectangle.portrait")
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        HStack(spacing: 12) {
                            Button {
                                isShowingManageCategories = true
                            } label: {
                                Image(systemName: "folder.badge.gearshape")
                            }
                            
                            Button {
                                isShowingAddCard = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .sheet(isPresented: $isShowingAddCard) { AddCardView() }
                .sheet(isPresented: $isShowingManageCategories) { CategoryManagementView() }
                .sheet(isPresented: $isShowingAllCardsList) { AllCardsListView() }
                .onAppear {
                    seedDefaultCategories()
                }
            }
        }
    }
    
    private func moveCategory(dragged: CardCategory, target: CardCategory) {
        
        guard
            let fromIndex = categories.firstIndex(where: { $0.id == dragged.id }),
            let toIndex = categories.firstIndex(where: { $0.id == target.id })
        else {
            return
        }
        
        var reordered = categories
        reordered.move(
            fromOffsets: IndexSet(integer: fromIndex),
            toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
        )
        
        for (index, category) in reordered.enumerated() {
            category.userOrder = index
        }
        
        try? modelContext.save()
    }
    
    private func onMoveCategory(from source: IndexSet, to destination: Int) {
        var updatedCategories = categories
        updatedCategories.move(fromOffsets: source, toOffset: destination)
        
        for (index, category) in updatedCategories.enumerated() {
            category.userOrder = index
        }
        
        try? modelContext.save()
    }
    
    private func seedDefaultCategories() {
        guard categories.isEmpty else { return }
        
        let defaults = [
            CardCategory(title: "Library", isSystem: true, colorHex: "#FF9500", userOrder: 0),      // Orange
            CardCategory(title: "Loyalty / Rewards", isSystem: true, colorHex: "#4CD964", userOrder: 1), // Green
            CardCategory(title: "Gym & Fitness", isSystem: true, colorHex: "#007AFF", userOrder: 2),    // Blue
            CardCategory(title: "Membership", isSystem: true, colorHex: "#5856D6", userOrder: 3),       // Purple
            CardCategory(title: "Identity / ID", isSystem: true, colorHex: "#FF2D55", userOrder: 4)     // Pink
        ]
        
        for category in defaults {
            modelContext.insert(category)
        }
        try? modelContext.save()
    }
    
    private func moveCategory(draggedID: String, target: CardCategory) {
        guard let fromIndex = categories.firstIndex(where: { $0.identifier == draggedID }),
              let toIndex = categories.firstIndex(where: { $0.identifier == target.identifier }) else {
            return
        }
        
        if fromIndex != toIndex {
            var updatedCategories = categories
            updatedCategories.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
            
            for (index, category) in updatedCategories.enumerated() {
                category.userOrder = index
            }
            
            try? modelContext.save()
        }
    }
        
    @ViewBuilder
    private func categoryRow(_ category: CardCategory) -> some View {
        NavigationLink {
            CategoryDetailListView(category: category)
        } label: {
            CategoryCardView(category: category)
        }
        .draggable(category.identifier) {
            CategoryCardView(category: category)
                .onAppear { draggedCategory = category }
        }
        .dropDestination(for: String.self) { items, location in
            draggedCategory = nil
            return true
        } isTargeted: { isTargeted in
            if isTargeted,
               let activeDragged = draggedCategory,
               activeDragged != category {
                
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    moveCategory(draggedID: activeDragged.identifier, target: category)
                }
            }
        }
        .zIndex(Double(categories.count + (categories.firstIndex(of: category) ?? 0)))
    }
}

struct CategoryCardView: View {
    let category: CardCategory
    var cardCount: Int {
        category.cards?.count ?? 0
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(category.title)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color.primary)
                    .lineLimit(1)
                
                Text("\(cardCount) \(cardCount == 1 ? "Card" : "Cards") Digitzed")
                    .font(.callout)
                    .foregroundStyle(Color.primary)
            }
            
            Spacer()
            
            Image(systemName: "arrow.up.right")
                .font(.body)
                .bold()
                .foregroundStyle(Color.primary)
                .padding(.top, 4)
        }
        .padding(.bottom, 80)
        .padding(.top, 25)
        .padding(.horizontal, 20)
        .background(Color(hex: category.colorHex))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.primary.opacity(0.6), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewContainer.shared)
}
