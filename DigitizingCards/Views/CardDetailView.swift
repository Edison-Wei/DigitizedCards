//
//  CardDetailView.swift
//  DigitizingCards
//
//  Created by Edison Wei on 2026-05-14.
//

import SwiftUI

struct CardDetailView: View {
    let card: ScannedCard
    let generator = BardcodeGenerator()
    
    @State private var originalBrightness: CGFloat?
    
    var body: some View {
            VStack(spacing: 20) {
                if let category = card.category {
                    Text(category.title.uppercased())
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(hex: category.colorHex).opacity(0.2))
                        .foregroundStyle(Color(hex: category.colorHex))
                        .cornerRadius(20)
                }
                
                Text(card.title)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)

                if let barcode = generator.generate(from: card.barcodeNumber) {
                    Image(uiImage: barcode)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(height: 150)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }

                Text(card.barcodeNumber)
                    .font(.system(.body, design: .monospaced))
                
                Spacer()
            }
            .padding()
            .background(
                ScreenReaderView { screen in
                    if originalBrightness == nil {
                        originalBrightness = screen.brightness
                    }
                    screen.brightness = 1.0
            })
            .onDisappear {
                restoreBrightness()
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIApplication.willResignActiveNotification)) {
                _ in restoreBrightness()
            }
        }
    
    private func restoreBrightness() {
        guard let originalBrightness else { return }
        
        if let screen = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .screen {
            screen.brightness = originalBrightness
        }
    }
}


struct ScreenReaderView: UIViewRepresentable {
    var onScreenDetected: (UIScreen) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        DispatchQueue.main.async {
            if let screen = view.window?.windowScene?.screen {
                onScreenDetected(screen)
            }
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}
