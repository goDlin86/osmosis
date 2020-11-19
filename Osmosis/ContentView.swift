//
//  ContentView.swift
//  Osmosis
//
//  Created by Денис on 12.11.2020.
//

import SwiftUI

struct PlaceHolder: View {
    var suit: String? = nil
    var width: CGFloat = 98
    var height: CGFloat = 150

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.defaultColor.opacity(0.8), lineWidth: 5)
            if let suit = self.suit {
                Text(suit)
                    .foregroundColor(Color.defaultColor.opacity(0.8))
                    .font(.largeTitle)
                    .scaleEffect(1.5)
            }
        }
        .frame(width: self.width, height: self.height)
    }
}

struct ContentView: View {
    @EnvironmentObject var deck: Deck
    @EnvironmentObject var stockPile: StockPile
    @EnvironmentObject var foundation: Foundation
    @EnvironmentObject var tableau: Tableau
    
    var body: some View {
        ZStack {
            VStack (spacing: 20) {
                HStack {
                    DeckAndStockPileView()
                    Spacer()
                    Text("RESTART")
                        .font(.largeTitle)
                        .onTapGesture {
                            self.tableau.cards = Array(repeating: [Card](), count: 4)
                            self.foundation.rows = Array(repeating: RowFoundation(cards: []), count: 4)
                            self.stockPile.cards.removeAll()
                            self.deck.reset()
                            
                            self.startGame()
                        }
                }.zIndex(2)
                HStack (spacing: 20) {
                    TableauView()
                    FoundationView().zIndex(-1)
                }
            }
        }
        .padding(20)
        .onAppear(perform: self.startGame)
    }
    
    func startGame() {
        for i in 0..<4 {
            for _ in 0..<4 {
                self.tableau.cards[i].append(self.deck.cards.popLast()!)
            }
        }
        self.tableau.printCards()
        
        self.foundation.addToPile(card: self.deck.cards.popLast()!)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceHolder()
    }
}


extension View {
    func stacked(at position: Int, in total: Int, by distance: CGFloat, horizontal: Bool = false) -> some View {
        let offset: CGFloat
        if horizontal {
            if total - position <= 3 {
                offset = CGFloat(total - position)
                return self.offset(CGSize(width: -offset * distance, height: offset * 3 - CGFloat(total) * 3))
            } else {
                offset = CGFloat(total - position)
                return self.offset(CGSize(width: -3 * distance, height: offset * 3 - CGFloat(total) * 3))
            }
        } else {
            offset = CGFloat(total - position)
            return self.offset(CGSize(width: 0, height: offset * distance - CGFloat(total) * distance))
        }
    }
}
