//
//  CellView.swift
//  GameOfLife
//
//  Created by Mario Rotz on 20.11.23.
//

import SwiftUI

// SwiftUI-Ansicht für eine einzelne Zelle
struct CellView: View {
    @Binding var isAlive: Bool
    
    var body: some View {
        Rectangle()
            .foregroundColor(isAlive ? .black : .white)
            .border(Color.gray, width: 0.5)
    }
}
