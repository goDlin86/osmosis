//
//  CardDesigns.swift
//  Osmosis
//
//  Created by Денис on 12.11.2020.
//

import SwiftUI

enum CardDesign: Int {
    case ace = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case jack = 11
    case queen = 12
    case king = 13
    case joker = 14
    
    func of(suit: Suit) -> AnyView {
        switch self {
        case .ace:
            return AnyView(Ace(suit: suit))
        case .two:
            return AnyView(Two(suit: suit))
        case .three:
            return AnyView(Three(suit: suit))
        case .four:
            return AnyView(Four(suit: suit))
        case .five:
            return AnyView(Five(suit: suit))
        case .six:
            return AnyView(Six(suit: suit))
        case .seven:
            return AnyView(Seven(suit: suit))
        case .eight:
            return AnyView(Eight(suit: suit))
        case .nine:
            return AnyView(Nine(suit: suit))
        case .ten:
            return AnyView(Ten(suit: suit))
        case .jack:
            return AnyView(Jack(suit: suit))
        case .queen:
            return AnyView(Queen(suit: suit))
        case .king:
            return AnyView(King(suit: suit))
        case .joker:
            return AnyView(Joker(suit: suit))
        }
    }
}


private struct Ace: View {
    var suit: Suit
    var body: some View {
        SuitView(suit: self.suit)
            .scaleEffect(2.5)
    }
}

private struct Two: View {
    var suit: Suit
    var body: some View {
        VStack {
            SuitView(suit: self.suit)
            Spacer()
            SuitView(suit: self.suit)
                .rotationEffect(.degrees(180))
        }.padding(30)
    }
}

private struct Three: View {
    var suit: Suit
    var body: some View {
        VStack {
            SuitView(suit: self.suit)
            Spacer()
            SuitView(suit: self.suit)
            Spacer()
            SuitView(suit: self.suit)
                .rotationEffect(.degrees(180))
        }.padding(.vertical, 25)
    }
}

private struct Four: View {
    var suit: Suit
    var body: some View {
        HStack {
            VStack {
                SuitView(suit: self.suit)
                Spacer()
                SuitView(suit: self.suit)
                    .rotationEffect(.degrees(180))
            }
                .padding([.top, .bottom], 35)
                .padding(.leading, 22)
            Spacer()
            VStack {
                SuitView(suit: self.suit)
                Spacer()
                SuitView(suit: self.suit)
                    .rotationEffect(.degrees(180))
            }
                .padding([.top, .bottom], 35)
                .padding(.trailing, 22)
        }
    }
}

private struct Five: View {
    var suit: Suit
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                }
                    .padding([.top, .bottom], 35)
                    .padding(.leading, 22)
                Spacer()
                VStack {
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                }
                    .padding([.top, .bottom], 35)
                    .padding(.trailing, 22)
            }
            SuitView(suit: self.suit)
        }
    }
}

private struct Six: View {
    var suit: Suit
    var body: some View {
        HStack {
            VStack {
                SuitView(suit: self.suit)
                Spacer()
                SuitView(suit: self.suit)
                Spacer()
                SuitView(suit: self.suit)
                    .rotationEffect(.degrees(180))
            }
                .padding([.top, .bottom], 25)
                .padding(.leading, 22)
            Spacer()
            VStack {
                SuitView(suit: self.suit)
                Spacer()
                SuitView(suit: self.suit)
                Spacer()
                SuitView(suit: self.suit)
                    .rotationEffect(.degrees(180))
            }
                .padding([.top, .bottom], 25)
                .padding(.trailing, 22)
        }
    }
}

private struct Seven: View {
    var suit: Suit
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                }
                    .padding([.top, .bottom], 25)
                    .padding(.leading, 22)
                Spacer()
                VStack {
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                }
                    .padding([.top, .bottom], 25)
                    .padding(.trailing, 22)
            }
            VStack {
                Spacer()
                SuitView(suit: self.suit)
                Spacer()
                    .frame(height: 10)
                SuitView(suit: self.suit)
                    .rotationEffect(.degrees(180))
                    .hidden()
                Spacer()
            }
        }
    }
}

private struct Eight: View {
    var suit: Suit
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                }
                    .padding([.top, .bottom], 25)
                    .padding(.leading, 22)
                Spacer()
                VStack {
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                }
                    .padding([.top, .bottom], 25)
                    .padding(.trailing, 22)
            }
            VStack {
                Spacer()
                SuitView(suit: self.suit)
                Spacer()
                    .frame(height: 10)
                SuitView(suit: self.suit)
                    .rotationEffect(.degrees(180))
                Spacer()
            }
        }
    }
}

private struct Nine: View {
    var suit: Suit
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                }
                    .padding(.vertical, 8)
                    .padding(.leading, 22)
                Spacer()
                VStack {
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                }
                    .padding(.vertical, 8)
                    .padding(.trailing, 22)
            }
            VStack {
                SuitView(suit: self.suit)
            }
        }
    }
}

private struct Ten: View {
    var suit: Suit
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                }
                    .padding(.vertical, 8)
                    .padding(.leading, 22)
                Spacer()
                VStack {
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                    Spacer()
                    SuitView(suit: self.suit)
                        .rotationEffect(.degrees(180))
                }
                    .padding(.vertical, 8)
                    .padding(.trailing, 22)
            }
            VStack {
                Spacer()
                SuitView(suit: self.suit)
                Spacer()
                    .frame(height: 42)
                SuitView(suit: self.suit)
                    .rotationEffect(.degrees(180))
                Spacer()
            }
        }
    }
}

private struct Jack: View {
    var suit: Suit
    var body: some View {
        ZStack {
            Ace(suit: suit)
            Text("J")
                .bold()
                .foregroundColor(Color.defaultColor)
                .font(.system(.largeTitle, design: Font.Design.serif))
        }
    }
}

private struct Queen: View {
    var suit: Suit
    var body: some View {
        ZStack {
            Ace(suit: suit)
            Text("Q")
                .bold()
                .foregroundColor(Color.defaultColor)
                .font(.system(.largeTitle, design: Font.Design.serif))
        }
    }
}

private struct King: View {
    var suit: Suit
    var body: some View {
        ZStack {
            Ace(suit: suit)
            Text("K")
                .bold()
                .foregroundColor(Color.defaultColor)
                .font(.system(.largeTitle, design: Font.Design.serif))
        }
    }
}

private struct Joker: View {
    var suit: Suit
    var string: String = (Int.random(in: 0...1) == 1 ? "J" : "j") + (Int.random(in: 0...1) == 1 ? "O" : "o") + (Int.random(in: 0...1) == 1 ? "K" : "k") + (Int.random(in: 0...1) == 1 ? "E" : "e") + (Int.random(in: 0...1) == 1 ? "R" : "r")
    var body: some View {
        Text(string)
            .bold()
            .foregroundColor(suit.color())
            .font(.system(.largeTitle, design: Font.Design.serif))
            .rotationEffect(.degrees(55))
    }
}


struct CardDesigns_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(value: 10, suit: .heart), flipState: .faceUp, cardState: .deck)
    }
}
