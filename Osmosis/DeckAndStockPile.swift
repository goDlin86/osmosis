//
//  DeckAndStockPile.swift
//  Osmosis
//
//  Created by Денис on 12.11.2020.
//

import SwiftUI

class Deck: ObservableObject {
    @Published var cards: [Card]
    @EnvironmentObject var stockPile: StockPile
    
    init(cards c: [Card]? = nil, shuffled: Bool = true) {
        self.cards = [Card]()
        self.reset(cards: c, shuffled: shuffled)
    }

    func reset(cards c: [Card]? = nil, shuffled: Bool = true) -> Void {
        if let b = c {
            cards = b
        } else {
            cards = []
            for i in 1...13 {
                cards.append(Card(value: i, suit: .club))
            }
            for i in 1...13 {
                cards.append(Card(value: i, suit: .heart))
            }
            for i in 1...13 {
                cards.append(Card(value: i, suit: .spade))
            }
            for i in 1...13 {
                cards.append(Card(value: i, suit: .diamond))
            }
        }
        if shuffled {
            cards.shuffle()
        }
        print("\(cards.count) cards created")
    }
    
    func contains(_ card: Card) -> Bool {
        return cards.contains(card)
    }
    
    func moveTopToStockPile() -> Void {
        if let card = self.cards.popLast() {
            self.stockPile.cards.append(card)
        }
    }
}

class StockPile: ObservableObject {
    var cards = [Card]()
}

struct DeckAndStockPileView: View {
    @EnvironmentObject var deck: Deck
    @EnvironmentObject var stockPile: StockPile
    @EnvironmentObject var foundation: Foundation

    var body: some View {
        HStack (spacing: 30) {
            ZStack {
                PlaceHolder(suit: "􀅈")
                    .contentShape(Rectangle())
                    .onTapGesture {
                        deck.cards = stockPile.cards.reversed()
                        stockPile.cards.removeAll()
                    }
                ForEach(0..<deck.cards.count, id: \.self) { index in
                    CardView(card: self.deck.cards[index], flipState: .faceDown, cardState: .deck)
                        //.stacked(at: index, in: self.deck.cards.count, by: 3)
                        //.shadow(color: Color.black.opacity(0.15), radius: 10)
                }
            }
            ZStack {
                ForEach(0..<stockPile.cards.count, id: \.self) { index in
                    CardView(card: self.stockPile.cards[index], flipState: .faceUp, cardState: .stockPile, onChanged: self.foundation.check)
                        //.stacked(at: index, in: self.stockPile.cards.count, by: 25, horizontal: true)
                        //.shadow(color: Color.black.opacity(0.15), radius: 10)
                        .offset(x: index > stockPile.cards.count - 3 ? (3 - CGFloat(stockPile.cards.count - index)) * 30 : 0, y: 0)
                        .allowsHitTesting(self.stockPile.cards.count - 1 == index)
                }
            }
        }
    }
}

struct DeckAndStockPile_Previews: PreviewProvider {
    static let deck = Deck(cards: nil, shuffled: true)
    static let stockPile = StockPile()
    
    static var previews: some View {
        PlaceHolder(suit: "􀅈")
//        DeckAndStockPileView()
//            .environmentObject(deck)
//            .environmentObject(stockPile)
    }
}
