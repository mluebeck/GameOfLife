//
//  ContentView.swift
//  GameOfLife
//
//  Created by Mario Rotz on 19.11.23.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var cellModel = CellModel(rows: 30, cols: 30)
    
    var body: some View {
        GameOfLifeView(cellModel: cellModel)
            .padding()
    }
}

#Preview {
    ContentView()
}
