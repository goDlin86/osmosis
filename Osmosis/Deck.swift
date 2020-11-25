//
//  DeckAndStockPile.swift
//  Osmosis
//
//  Created by Денис on 12.11.2020.
//

import SwiftUI

class Deck: ObservableObject {
    @Published var cards: [Card]
    
    let cardWidth: CGFloat = 100
    let cardHeight: CGFloat = 150
    
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
    
    func flip(card: Card) {
        if let index = cards.firstIndex(of: card) {
            cards[index].flipState = cards[index].flipState == .faceUp ? .faceDown : .faceUp
        }
    }
    
    func moveTopToStockPile() -> Void {
        for _ in 0..<3 {
            if let index = cards.lastIndex(where: { $0.cardState == .deck }) {
                cards[index].cardState = .stockPile
                cards[index].flipState = .faceUp
                cards[index].allowTap = false
                cards[index].offset = CGSize(width: cardWidth + 30, height: 0)
                cards[index].zIndex = Double(cards.filter { $0.cardState == .stockPile }.count)
            }
        }
        
        let stockPile = cards.filter { $0.cardState == .stockPile }
        for i in 0..<stockPile.count {
            if let index = cards.firstIndex(of: stockPile[i]) {
                cards[index].offset = CGSize(width: cardWidth + 30, height: 0)
                if (i < 2) {
                    cards[index].offset.width += CGFloat(2 -  i) * (cardWidth - 70)
                }
                cards[index].allowTap = i == 0 ? true : false
            }
        }
    }
}
