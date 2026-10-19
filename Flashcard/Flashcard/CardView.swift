//
//  CardView.swift
//  MemoryGame
//
//  Created by amanda torres on 10/3/26.
//


import SwiftUI

// Card model with unique ID, symbol, and visibility state
struct Card: Identifiable, Equatable {
    let id = UUID()
    let symbol: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}

struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            // Card Back (Face-down)
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(radius: 3)
                .opacity(card.isFaceUp ? 0 : 1)
            
            // Card Front (Face-up)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(radius: 3)
                
                Text(card.symbol)
                    .font(.system(size: 40))
            }
            .opacity(card.isFaceUp ? 1 : 0)
        }
        .aspectRatio(2/3, contentMode: .fit)
        // Hide card completely if matched
        .opacity(card.isMatched ? 0 : 1)
        .animation(.easeInOut(duration: 0.3), value: card.isFaceUp)
        .animation(.easeInOut(duration: 0.3), value: card.isMatched)
    }
}

#Preview {
    CardView(card: Card(symbol: "🐶", isFaceUp: true))
        .padding()
}
