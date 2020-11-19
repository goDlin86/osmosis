//
//  Foundation.swift
//  Osmosis
//
//  Created by Денис on 13.11.2020.
//

import SwiftUI

struct RowFoundation {
    var suit: Suit?
    var cards: [Card]
}

class Foundation: ObservableObject {
    @Published var rows: [RowFoundation]
    @Published var foundationFrames: [CGRect]
    
    init() {
        self.rows = Array(repeating: RowFoundation(cards: []), count: 4)
        self.foundationFrames = [CGRect](repeating: .zero, count: 4)
    }
    
    func addToPile(card: Card) {
        if let r = self.rows.firstIndex(where: {$0.suit == card.suit}) {
            self.rows[r].cards.append(card)
        } else {
            if let i = self.rows.firstIndex(where: {$0.suit == nil}) {
                self.rows[i] = RowFoundation(suit: card.suit, cards: [card])
            }
        }
    }
    
    func check(location: CGPoint, card: Card) -> DragState {
        if let f = foundationFrames.firstIndex(where: { $0.contains(location) }) {
            let index = self.rows.firstIndex {$0.suit == card.suit || $0.suit == nil}
            if index == f {
                if index == 0 {
                    return .good
                }
                if self.rows[index!].suit == nil {
                    return self.rows[0].cards[0].value == card.value ? .good : .bad
                } else {
                    return self.rows[index! - 1].cards.first(where: {$0.value == card.value}) == nil ? .bad : .good
                }
            }
            return .bad
        }
        return .unknown
    }
    
}

struct FoundationView: View {
    @EnvironmentObject var foundation: Foundation

    var body: some View {
        VStack (spacing: 15) {
            ForEach(0..<4, id: \.self) { i in
                RowCardsView(cards: self.foundation.rows[i].cards)
                    .frame(width: 500)
                    .overlay(
                        GeometryReader { geo in
                            Color.clear//.red.opacity(0.5)
                            .onAppear {
                                self.foundation.foundationFrames[i] = geo.frame(in: .global)
                            }
                        }
                    )
            }
        }
    }
}

struct Foundation_Previews: PreviewProvider {
    static let foundation = Foundation()
    //foundation.rows[0] = RowFoundation(suit: .heart, cards: [Card](repeating: Card.example, count: 7))
    
    static var previews: some View {
        FoundationView()
            .environmentObject(foundation)
    }
}
