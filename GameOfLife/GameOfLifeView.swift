//
//  GameOfLifeView.swift
//  GameOfLife
//
//  Created by Mario Rotz on 20.11.23.
//

import SwiftUI

// SwiftUI-Ansicht für das Spielfeld

struct GameOfLifeView: View {
    let size = CGSize(width: 20.0, height: 20.0)
    @ObservedObject var cellModel: CellModel
    
    var body: some View {
        VStack(spacing:0.0) {
            ForEach(0..<Int(cellModel.rows), id: \.self) { row in
                HStack(spacing:0.0) {
                    ForEach(0..<Int(cellModel.cols), id: \.self) { col in
                        CellView(isAlive: self.$cellModel.grid[row][col])
                            .frame(width: size.width, height: size.height)
                            .onTapGesture {
                                self.cellModel.toggleCell(row: row, col: col)
                            }
                    }
                }
            }
            VStack {
                Spacer()
                HStack(spacing: 10.0, content: {
                    
                    Button("Reset") {
                        self.cellModel.resetGrid()
                    }
                    Button("Start") {
                        self.cellModel.resetGrid()
                    }
                    Button("Step") {
                        self.cellModel.step()
                    }
                })
            }
        }
    }
}
