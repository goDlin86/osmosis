//
//  RowCardsView.swift
//  Osmosis
//
//  Created by Денис on 13.11.2020.
//

import SwiftUI

struct RowCardsView: View {
    var cards = [Card]()
    
    var body: some View {
        HStack {
            ZStack (alignment: .topLeading) {
                PlaceHolder()
                HStack (spacing: -70) {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: self.cards[index], flipState: .faceUp, cardState: .foundation)
                            //.stacked(at: index, in: self.foundation.diamonds.count, by: 3)
                            .shadow(color: Color.black.opacity(0.15), radius: 10)
                            .allowsHitTesting(false)
                    }
                }
            }
            Spacer()
        }
    }
}

struct RowCardsView_Previews: PreviewProvider {
    static var previews: some View {
        RowCardsView(cards: [Card](repeating: Card.example, count: 7))
    }
}
