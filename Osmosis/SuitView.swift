//
//  SuitView.swift
//  Osmosis
//
//  Created by Денис on 12.11.2020.
//

import SwiftUI

struct SuitView: View {
    var suit: Suit
    
    private let suitSize = Font.TextStyle.title
    private let suitScale: CGFloat = 0.95
    private let fontDesign = Font.Design.serif
    
    var body: some View {
        Text(suit.string())
            .foregroundColor(suit.color())
            .font(.system(suitSize, design: fontDesign))
            .scaleEffect(suitScale)
    }
}

struct SuitView_Previews: PreviewProvider {
    static var previews: some View {
        SuitView(suit: .heart)
    }
}
