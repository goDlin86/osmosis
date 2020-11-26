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
    var flipState: FlipState = .faceDown
    var cardState: CardState = .deck
    var allowTap: Bool = true
    var offset: CGSize = .zero
    var zIndex: Double = 0
    var rowIndex: Int? // for tableau and foundation
    
    init (value: Int, suit: Suit) {
        self.value = value
        self.suit = suit
    }
    static let example = Card(value: 3, suit: .club)
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.value == rhs.value && lhs.suit == rhs.suit
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
    var width: CGFloat = 100
    var height: CGFloat = 150
    
    @State var dragAmount = CGSize.zero
    @State var dragState = DragState.unknown
    var onChanged: ((CGPoint, Card) -> DragState)?
    var onEnded: ((CGPoint, Card) -> Void)?
    
    @EnvironmentObject var deck: Deck
    
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            CardBack()
                .rotation3DEffect(.degrees(card.flipState == .faceDown ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                .opacity(card.flipState == .faceDown ? 1 : 0)
            CardFront(value: card.value, suit: card.suit)
                .rotation3DEffect(.degrees(card.flipState != .faceDown ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                .opacity(card.flipState != .faceDown ? 1 : 0)
                .overlay(dragColor)
        }
            .frame(width: width, height: height)
            .shadow(color: Color.clear, radius: 0)
            .shadow(color: Color.blue, radius: 0)
            .zIndex(dragAmount == .zero ? card.zIndex : Double.greatestFiniteMagnitude)
            .offset(dragAmount == .zero ? card.offset : dragAmount)
            .opacity(self.opacity)
            .allowsHitTesting(card.allowTap)
            .simultaneousGesture (
                DragGesture(coordinateSpace: .global)
                    .onChanged {
                        if self.card.flipState == .faceUp && (self.card.cardState == .tableau || self.card.cardState == .stockPile) {
                            self.dragAmount = CGSize(width: $0.translation.width + self.card.offset.width, height: -$0.translation.height + self.card.offset.height)
                            self.dragState = self.onChanged?($0.location, self.card) ?? .unknown
                        }
                    }
                    .onEnded {
                        if self.dragState == .good {
                            self.onEnded?($0.location, self.card)
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
                            switch self.card.cardState {
                            case .tableau:
                                withAnimation {
                                    if self.card.flipState == .faceDown {
                                        self.deck.flip(card: self.card)
                                    }
                                }
                                return
                            case .deck:
                                withAnimation {
                                    if self.card.flipState == .faceDown {
                                        self.deck.moveTopToStockPile()
                                    }
                                }
                                return
                            case .stockPile:
                                withAnimation {
                                    return
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
        CardView(card: Card(value: 4, suit: .heart), width: 100, height: 150)
    }
}
