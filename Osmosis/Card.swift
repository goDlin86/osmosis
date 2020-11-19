//
//  Card.swift
//  Osmosis
//
//  Created by Денис on 12.11.2020.
//

import SwiftUI

struct Card: Equatable {
    var value: Int
    var suit: Suit
    
    init (value: Int, suit: Suit) {
        self.value = value
        self.suit = suit
    }
    static let example = Card(value: 3, suit: .club)
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.value == rhs.value && lhs.suit == rhs.suit
    }
    
    func findTableauIndex(tableau: Tableau) -> (column: Int, row: Int)? {
        for i in 0..<tableau.cards.count {
            for j in 0..<tableau.cards[i].count {
                if tableau.cards[i][j] == self {
                    return (i, j)
                }
            }
        }
        return nil
    }
}

enum Suit: String {
    case club
    case heart
    case spade
    case diamond
    
    func string() -> String {
        switch self {
        case .heart:
            return "♥️"
        case .diamond:
            return "♦️"
        case .spade:
            return "♠️"
        case .club:
            return "♣️"
        }
    }
    
    func color() -> Color {
        switch self {
        case .heart:
            return .red
        case .diamond:
            return .red
        case .spade:
            return .black
        case .club:
            return .black
        }
    }
}

enum CardState {
    case deck
    case stockPile
    case foundation
    case tableau
}

enum FlipState {
    case faceDown, faceUp
}

enum DragState {
    case good, bad, unknown
}


struct CardView: View, Identifiable {
    var card: Card
    var id = UUID()
    @State var flipState: FlipState? = .faceDown
    @State var dragAmount = CGSize.zero
    @State var dragState = DragState.unknown
    @State var cardState: CardState
    var onChanged: ((CGPoint, Card) -> DragState)?
    var onEnded: ((CGPoint, Card) -> Void)?
    
    @EnvironmentObject var deck: Deck
    @EnvironmentObject var stockPile: StockPile
    @EnvironmentObject var foundation: Foundation
    @EnvironmentObject var tableau: Tableau
    
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            CardBack()
                .rotation3DEffect(.degrees(flipState == .faceDown ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                .opacity(flipState == .faceDown ? 1 : 0)
            CardFront(value: self.card.value, suit: self.card.suit)
                .rotation3DEffect(.degrees(flipState != .faceDown ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                .opacity(flipState != .faceDown ? 1 : 0)
                .overlay(dragColor)
        }
            .frame(width: 102, height: 150)
            .shadow(color: Color.clear, radius: 0)
            .shadow(color: Color.blue, radius: 0)
            .zIndex(dragAmount == .zero ? 0 : Double.greatestFiniteMagnitude)
            .offset(dragAmount)
            .opacity(self.opacity)
            .simultaneousGesture (
                DragGesture(coordinateSpace: .global)
                    .onChanged {
                        if self.flipState == .faceUp && (self.cardState == .tableau || self.cardState == .stockPile) {
                            self.dragAmount = CGSize(width: $0.translation.width, height: -$0.translation.height)
                            self.dragState = self.onChanged?($0.location, self.card) ?? .unknown
//                            if let index = self.card.findTableauIndex(tableau: self.tableau) {
//                                self.tableau.activeRow = index.column
//                            }
                        }
                    }
                    .onEnded {
                        if self.dragState == .good {
                            self.onEnded?($0.location, self.card)
                            if let index = self.card.findTableauIndex(tableau: self.tableau) {
                                self.cardState = .foundation
                                self.foundation.addToPile(card: self.tableau.cards[index.column].popLast()!)
                                self.tableau.printCards()
                                self.opacity = 0
                                //self.tableau.cards[index.column].last.flip()
                            } else {
                                self.cardState = .foundation
                                self.foundation.addToPile(card: self.stockPile.cards.popLast()!)
                                self.opacity = 0
                            }
                            
                            //check victory
                            if self.foundation.rows[3].cards.count == 13 {
                                print("VICTORY")
                            }
                        }
                        withAnimation {
                            self.dragAmount = .zero
                        }
                    }
            )
            .gesture(
                TapGesture()
                    .onEnded {
                        withAnimation {
                            switch self.cardState {
                            case .tableau:
                                withAnimation {
                                    if self.flipState == .faceDown {
                                        self.flip()
                                    }
                                }
                                return
                            case .deck:
                                withAnimation {
                                    if self.flipState == .faceDown && self.deck.cards.last == self.card {
                                        for _ in 0..<3 {
                                            if let c = self.deck.cards.popLast() {
                                            self.stockPile.cards.append(c)
                                            }
                                        }
                                        
                                    }
                                }
                                return
                            case .stockPile:
                                withAnimation {
                                    switch self.card.suit {
                                    case .club:
    //                                    if (self.foundation.clubs.last ?? Card(value: 0, suit: .club)).value == self.card.value - 1 {
    //                                        self.foundation.clubs.append(self.stockPile.cards.popLast()!)
    //                                    }
                                        return
                                    case .heart:
    //                                    if (self.foundation.hearts.last ?? Card(value: 0, suit: .heart)).value == self.card.value - 1 {
    //                                        self.foundation.hearts.append(self.stockPile.cards.popLast()!)
    //                                    }
                                        return
                                    case .spade:
    //                                    if (self.foundation.spades.last ?? Card(value: 0, suit: .spade)).value == self.card.value - 1 {
    //                                        self.foundation.spades.append(self.stockPile.cards.popLast()!)
    //                                    }
                                        return
                                    case .diamond:
    //                                    if (self.foundation.diamonds.last ?? Card(value: 0, suit: .diamond)).value == self.card.value - 1 {
    //                                        self.foundation.diamonds.append(self.stockPile.cards.popLast()!)
    //                                    }
                                        return
                                    }
                                }
                            case .foundation:
                                withAnimation {
                                    return
                                }
                            }
                        }
                    }
            )
    }
        
    func flip() {
        self.flipState = self.flipState == .faceUp ? .faceDown : .faceUp
    }
    
    var dragColor: Color {
        if self.dragState == .unknown || self.dragAmount == .zero {
            return Color.clear//blue.opacity(0.5)
        } else if self.dragState == .good {
            return Color.green.opacity(0.5)
        } else if self.dragState == .bad {
            return Color.red.opacity(0.5)
        } else {
            return Color.clear
        }
    }
}

private struct CardFront: View {
    var value: Int
    var suit: Suit
    var valueString: String {
        if (value == 1) {
            return "A"
        } else if (value == 11) {
            return "J"
        } else if (value == 12) {
            return "Q"
        } else if (value == 13) {
            return "K"
        } else if (value == 14) {
            return ""
        } else {
            return "\(value)"
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.defaultColor)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.defaultColor, lineWidth: 7))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(self.suit.color(), lineWidth: 3))
            ZStack {
                HStack {
                    VStack (spacing: 2){
                        Text(valueString)
                            .bold()
                            .foregroundColor(self.suit.color())
                            .font(.system(.title, design: .serif))
                        if (self.value < 14) {
                            Text(self.suit.string()) .foregroundColor(self.suit.color())
                                .font(.system(.body, design: .serif))
                        }
                        Spacer()
                    }
                        .scaleEffect(0.9)
                        .padding(.leading, 3)
                        .padding(.top, -7)
                    Spacer()
                    VStack (spacing: 2){
                        Text(valueString)
                            .bold()
                            .foregroundColor(self.suit.color())
                            .font(.system(.title, design: .serif))
                            if (self.value < 14) {
                                Text(self.suit.string())
                                    .foregroundColor(self.suit.color())
                                    .font(.system(.body, design: .serif))
                            }
                        Spacer()
                    }
                        .scaleEffect(0.9)
                        .padding(.leading, 3)
                        .padding(.top, -7)
                        .rotationEffect(.degrees(180))
                }
                
            }
            CardDesign(rawValue: value)?.of(suit: self.suit)
        }
    }
}

private struct CardBack: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.defaultColor, lineWidth: 7))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 3))
            Text("􀆬")
                .foregroundColor(Color.defaultColor)
                .font(.largeTitle)
        }
    }
}


extension Color {
    public static let defaultColor: Color = Color.white// Color.init(NSColor.controlBackgroundColor)
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(value: 4, suit: .heart), flipState: .faceUp, cardState: .deck)
    }
}
