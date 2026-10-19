//
//  ContentView.swift
//  MemoryGame
//
//  Created by amanda torres on 10/3/26.
//

import SwiftUI

struct ContentView: View {
    // List of available emoji symbols to build pairs
    private let availableSymbols = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮"]
    
    // Game state variables
    @State private var selectedNumberOfPairs: Int = 6
    @State private var cards: [Card] = []
    @State private var indexOfFirstSelectedCard: Int? = nil
    @State private var isProcessing: Bool = false // Prevents fast tapping while cards are flipping back
    
    // Grid column configuration
    private let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 12)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Memory Game")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            // Picker to select number of pairs
            HStack {
                Text("Number of Pairs:")
                    .font(.headline)
                
                Picker("Pairs", selection: $selectedNumberOfPairs) {
                    Text("4").tag(4)
                    Text("6").tag(6)
                    Text("8").tag(8)
                    Text("10").tag(10)
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedNumberOfPairs) { _, _ in
                    resetGame()
                }
            }
            .padding(.horizontal)
            
            // ScrollView for extra cards & grid layout
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index])
                            .onTapGesture {
                                handleCardTap(at: index)
                            }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Reset / New Game button
            Button(action: resetGame) {
                Label("Reset Game", systemImage: "arrow.clockwise")
                    .font(.title2)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onAppear {
            resetGame()
        }
    }
    
    // MARK: - Game Logic Methods
    
    private func resetGame() {
        var newCards: [Card] = []
        let chosenSymbols = Array(availableSymbols.prefix(selectedNumberOfPairs))
        
        // Create matching pairs
        for symbol in chosenSymbols {
            newCards.append(Card(symbol: symbol))
            newCards.append(Card(symbol: symbol))
        }
        
        // Shuffle the deck and update state
        cards = newCards.shuffled()
        indexOfFirstSelectedCard = nil
        isProcessing = false
    }
    
    private func handleCardTap(at index: Int) {
        // Ignore tap if processing match delay, card is face up, or card is already matched
        guard !isProcessing, !cards[index].isFaceUp, !cards[index].isMatched else { return }
        
        // Flip selected card face up
        cards[index].isFaceUp = true
        
        if let firstIndex = indexOfFirstSelectedCard {
            // A card was previously selected -> Check for match
            if cards[firstIndex].symbol == cards[index].symbol {
                // MATCH FOUND: Disappear both cards
                isProcessing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    cards[firstIndex].isMatched = true
                    cards[index].isMatched = true
                    indexOfFirstSelectedCard = nil
                    isProcessing = false
                }
            } else {
                // NO MATCH: Flip both cards back down after a short delay
                isProcessing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    cards[firstIndex].isFaceUp = false
                    cards[index].isFaceUp = false
                    indexOfFirstSelectedCard = nil
                    isProcessing = false
                }
            }
        } else {
            // First card selected
            indexOfFirstSelectedCard = index
        }
    }
}

#Preview {
    ContentView()
}
