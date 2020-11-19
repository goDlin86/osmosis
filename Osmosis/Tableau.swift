//
//  Tableau.swift
//  Osmosis
//
//  Created by Денис on 12.11.2020.
//

import SwiftUI

class Tableau: ObservableObject {
    @Published var cards = [[Card]]()
    @Published var activeRow = 0
    
    init() {
        self.cards = Array(repeating: [Card](), count: 4)
    }
    
    func printCards() -> Void {
        print("")
        for i in (0..<self.cards.count).reversed() {
            for j in 0..<self.cards[i].count {
                var letter: String {
                    if self.cards[i][j].value > 1 && self.cards[i][j].value < 11 {
                        return "\(self.cards[i][j].value)"
                    } else if self.cards[i][j].value == 1 {
                        return "A"
                    } else if self.cards[i][j].value == 11 {
                        return "J"
                    } else if self.cards[i][j].value == 12 {
                        return "Q"
                    } else if self.cards[i][j].value == 13 {
                        return "K"
                    } else {
                        return "ERROR"
                    }
                }
                print("\(letter)\(self.cards[i][j].suit.string())", terminator: " \t")
            }
            print("")
        }
    }
}

struct TableauView: View {
    @EnvironmentObject var deck: Deck
    @EnvironmentObject var tableau: Tableau
    @EnvironmentObject var foundation: Foundation
    
    @State var z = 0

    var body: some View {
        VStack (spacing: 15) {
            ForEach(0..<4) { i in
                HStack {
                    ZStack {
                        PlaceHolder()
                        HStack (spacing: -80) {
                            ForEach(0..<4) { j in
                                if j <= self.numberOfCardsIn(row: i) {
                                    CardView(card: self.tableau.cards[i][j], flipState: j < self.numberOfCardsIn(row: i) ? .faceDown : .faceUp, cardState: .tableau, onChanged: self.foundation.check)
                                        //.stacked(at: j, in: self.tableau.cards[i].count, by: -40)
                                        .shadow(color: Color.black.opacity(0.15), radius: 10)
                                        .allowsHitTesting(j == self.numberOfCardsIn(row: i))
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .zIndex(i == self.tableau.activeRow ? 1 : 0)
            }
        }
    }

    private func numberOfCardsIn(row: Int) -> Int {
        return self.tableau.cards[row].count - 1
    }
}

struct Tableau_Previews: PreviewProvider {
    static let deck = Deck(cards: nil, shuffled: true)
    static let tableau = Tableau()
    
    static var previews: some View {
        TableauView()
            .environmentObject(deck)
            .environmentObject(tableau)
    }
}
