//
//  CategoryDetailListView.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-20.
//

import SwiftUI
import SwiftData

struct CategoryDetailListView: View {
    let category: CardCategory
    @Environment(\.modelContext) private var modelContext
    
    @Query private var cards: [ScannedCard]
    
    init(category: CardCategory) {
        self.category = category
        let categoryId = category.id
        self._cards = Query(
            filter: #Predicate<ScannedCard> { card in
                card.category?.id == categoryId
            },
            sort: \ScannedCard.title
        )
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.teal.opacity(0.2),
                Color.gray.opacity(0.3),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                HStack {
                    Text(category.title)
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding(20)
                .background(Color(hex: category.colorHex).opacity(0.4))
                .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                List {
                    ForEach(cards) { card in
                        NavigationLink(destination: CardDetailView(card: card)) {
                            HStack {
                                Capsule()
                                    .fill(Color(hex: card.category?.colorHex ?? "#8E8E93"))
                                    .frame(width: 5, height: 35)
                                
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
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("\(category.title) Detail")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func deleteCards(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(cards[index])
        }
    }
}

// MARK: - Extracted Component for Lists
struct CardDetailRow: View {
    let card: ScannedCard
    var showCategoryLabel = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(card.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Added on \(card.dateAdded.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Show specific barcodeFormat (Requirement 1)
                Text(card.barcodeFormat)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(.systemGray5))
                    .cornerRadius(4)
            }
            
            // Display optional notes (Requirement 1 & 2)
            if let notes = card.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .italic()
                    .lineLimit(2)
                    .padding(.top, 2)
            }
            
            // Requirement 2: Optional category label
            if showCategoryLabel, let category = card.category {
                HStack {
                    Spacer()
                    Text(category.title)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(hex: category.colorHex).opacity(0.15))
                        .foregroundStyle(Color(hex: category.colorHex))
                        .cornerRadius(5)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// Helper extension to selectively corner radius on specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
