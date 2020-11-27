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
            Text("RESTART")
                .font(.largeTitle)
                .offset(x: 450, y: 10)
                .onTapGesture {
                    self.deck.resetGame()
                    self.startGame()
                }
            PlaceHolder(suit: "􀅈")
                .contentShape(Rectangle())
                .onTapGesture {
                    let stockPile = deck.cards.filter { $0.cardState == .stockPile }
                    for i in 0..<stockPile.count {
                        if let index = deck.cards.firstIndex(of: stockPile[i]) {
                            deck.applyCard(index: index, allowTap: true)
                        }
                    }
                }
            ForEach(0..<4) { i in
                PlaceHolder().offset(deck.getOffset(type: .tableau, row: i))
                PlaceHolder().offset(deck.getOffset(type: .foundation, row: i))
            }
         
            ForEach(0..<deck.cards.count, id: \.self) { i in
                CardView(
                    card: self.deck.cards[i],
                    width: cardWidth,
                    height: cardHeight,
                    onChanged: deck.check,
                    onEnded: deck.addCard
                )
            }
        }
        .position(x: cardWidth/2 + 30 , y: cardHeight/2 + 30)
        .frame(width: cardWidth*9, height: cardHeight*5 + 60  + 65)
        .onAppear { self.startGame() }
    }
    
    func startGame() {
        for j in 0..<4 {
            for i in 0..<4 {
                withAnimation {
                    deck.topCardToTableau(row: j, i: i)
                }
            }
        }

        if let index = deck.cards.lastIndex(where: { $0.cardState == .deck }) {
            withAnimation {
                deck.cardToFoundation(index: index, row: 0, zindex: 0)
            }
        }
    }
}

struct ContentView1_Previews: PreviewProvider {
    static let deck = Deck()
    
    static var previews: some View {
        ContentView()
            .environmentObject(deck)
    }
}
