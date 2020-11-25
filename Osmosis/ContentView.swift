//
//  ContentView.swift
//  Osmosis
//
//  Created by Денис on 20.11.2020.
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
    
    let cardWidth: CGFloat = 100
    let cardHeight: CGFloat = 150
    
    var body: some View {
        ZStack {
            PlaceHolder(suit: "􀅈")
            ForEach(0..<4) { i in
                PlaceHolder().offset(getOffset(type: .tableau, row: i))
                PlaceHolder().offset(getOffset(type: .foundation, row: i))
            }
         
            ForEach(0..<deck.cards.count, id: \.self) { i in
                CardView(
                    card: self.deck.cards[i],
                    width: cardWidth,
                    height: cardHeight
                )
            }
        }
        .position(x: cardWidth/2 + 30 , y: cardHeight/2 + 30)
        .frame(width: cardWidth*9, height: cardHeight*5 + 60  + 65)
        .onAppear { self.startGame() }
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
    
    func startGame() {
        for j in 0..<4 {
            for i in 0..<4 {
                topCardToTableau(row: j, i: i)
            }
        }

        if let index = deck.cards.lastIndex(where: { $0.cardState == .deck }) {
            cardToFoundation(index: index, row: 0, zindex: 0)
        }
    }
    
    func topCardToTableau(row: Int, i: Int) {
        if let index = deck.cards.lastIndex(where: { $0.cardState == .deck }) {
            deck.cards[index].cardState = .tableau
            deck.cards[index].flipState = i == 3 ? .faceUp : .faceDown
            deck.cards[index].allowTap = i < 3 ? false : true
            deck.cards[index].offset = getOffset(type: .tableau, row: row, index: i)
            deck.cards[index].zIndex = Double(i)
            deck.cards[index].rowIndex = row
        }
    }
   
    func cardToFoundation(index: Int, row: Int, zindex: Double) {
        deck.cards[index].cardState = .foundation
        deck.cards[index].flipState = .faceUp
        deck.cards[index].allowTap = false
        deck.cards[index].offset = getOffset(type: .foundation, row: row)
        deck.cards[index].zIndex = zindex
        deck.cards[index].rowIndex = row
    }
}

struct ContentView1_Previews: PreviewProvider {
    static let deck = Deck()
    
    static var previews: some View {
        ContentView()
            .environmentObject(deck)
    }
}
