//
//  DeckAndStockPile.swift
//  Osmosis
//
//  Created by Денис on 12.11.2020.
//

import SwiftUI

class Deck: ObservableObject {
    @Published var cards: [Card]
    @Published var foundationFrames: [CGRect]
    
    let cardWidth: CGFloat = 100
    let cardHeight: CGFloat = 150
    
    let windowHeight: CGFloat = 150 * 5 + 60  + 65
    
    init(cards c: [Card]? = nil, shuffled: Bool = true) {
        self.cards = [Card]()
        self.foundationFrames = [CGRect](repeating: .zero, count: 4)
        for i in 0..<4 {
            let offset = getOffset(type: .foundation, row: i)
            foundationFrames[i] = CGRect(
                x: offset.width + 30,
                y: windowHeight - 30 - (offset.height + cardHeight),
                width: 550,
                height: cardHeight
            )
        }
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
    
    func resetGame() {
        for i in 0..<cards.count {
            applyCard(
                index: i,
                allowTap: true
            )
        }
        cards.shuffle()
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
    
    func getOffset(type: CardState, row: Int = 0, index: Int = 0) -> CGSize {
        switch type {
        case .deck:
            return .zero
            
        case .stockPile:
            let offset = CGSize(width: cardWidth + 30, height: 0)
            return offset

       case .tableau:
            let offset = CGSize(
                width: CGFloat(index) * (cardWidth - 80),
                height: cardHeight + 20 + CGFloat(row) * (cardHeight + 15)
            )
            return offset

       case .foundation:
            let offset = CGSize(
                width: (cardWidth - 80) * 3 + cardWidth + 60 + CGFloat(index) * (cardWidth - 70),
                height: cardHeight + 20 + CGFloat(row) * (cardHeight + 15)
            )
            return offset
       }
    }
    
    func applyCard(
        index: Int,
        cardState: CardState = .deck,
        flipState: FlipState = .faceDown,
        allowTap: Bool = false,
        offset: CGSize = .zero,
        zIndex: Double = 0,
        rowIndex: Int = 0
    ) {
        cards[index].cardState = cardState
        cards[index].flipState = flipState
        cards[index].allowTap = allowTap
        cards[index].offset = offset
        cards[index].zIndex = zIndex
        cards[index].rowIndex = rowIndex
    }
    
    func topCardToTableau(row: Int, i: Int) {
        if let index = cards.lastIndex(where: { $0.cardState == .deck }) {
            applyCard(
                index: index,
                cardState: .tableau,
                flipState: i == 3 ? .faceUp : .faceDown,
                allowTap: i < 3 ? false : true,
                offset: getOffset(type: .tableau, row: row, index: i),
                zIndex: Double(i),
                rowIndex: row
            )
        }
    }
   
    func cardToFoundation(index: Int, row: Int, zindex: Int) {
        applyCard(
            index: index,
            cardState: .foundation,
            flipState: .faceUp,
            offset: getOffset(type: .foundation, row: row, index: zindex),
            zIndex: Double(zindex),
            rowIndex: row
        )
    }
    
    func check(location: CGPoint, card: Card) -> DragState {
        if let f = foundationFrames.firstIndex(where: { $0.contains(location) }) {
            var rows = Array(repeating: [Card](), count: 4)
            for i in 0..<4 {
                rows[i] = cards.filter { $0.cardState == .foundation && $0.rowIndex == i }
            }
            
            if let index = rows.firstIndex(where: {$0.count > 0 && $0[0].suit == card.suit}) ?? rows.firstIndex(where: {$0.count == 0}) {
                if index == f {
                    if index == 0 {
                        return .good
                    }
                    if rows[index].count == 0 {
                        return rows[0].first { $0.zIndex == 0 }!.value == card.value ? .good : .bad
                    }
                    return rows[index - 1].firstIndex(where: {$0.value == card.value}) == nil ? .bad : .good
                }
                return .bad
            }
            return .bad
        }
        return .unknown
    }
    
    func addCard(location: CGPoint, card: Card) {
        //flip and allow tap next card
        if card.cardState == .tableau {
            if card.zIndex > 0 {
                if let index = cards.firstIndex(where: { $0.cardState == .tableau && $0.rowIndex == card.rowIndex && $0.zIndex == card.zIndex - 1 }) {
                    withAnimation {
                        cards[index].flipState = .faceUp
                        cards[index].allowTap = true
                    }
                }
            }
        }
        if card.cardState == .stockPile {
            if card.zIndex > 0 {
                if let index = cards.firstIndex(where: { $0.cardState == .stockPile && $0.zIndex == card.zIndex - 1 }) {
                    cards[index].allowTap = true
                }
            }
        }
        
        if let index = cards.firstIndex(of: card) {
            if let f = foundationFrames.firstIndex(where: { $0.contains(location) }) {
                let row = cards.filter { $0.cardState == .foundation && $0.rowIndex == f }
                cardToFoundation(index: index, row: f, zindex: row.count)
            }
        }
        
        //check victory
//                            if self.foundation.rows[3].cards.count == 13 {
//                                print("VICTORY")
//                            }
    }
}
