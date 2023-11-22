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
    @ObservedObject var cellModel: CellModel = CellModel(rows: 20, cols: 10)
    
    var body: some View {
         
        VStack(spacing:0.0) {
            ForEach(0..<cellModel.playground.rowSize, id: \.self) { row in
                HStack(spacing:0.0) {
                    ForEach(0..<cellModel.playground.columnSize, id: \.self) { col in
                        CellView(isAlive: self.$cellModel.playground.array[row][col])
                            .frame(width: size.width, height: size.height)
                            .onTapGesture {
                                self.cellModel.toggleCell(row: row, col: col)
                            }
                    }
                }
            }
           
            VStack {
                Text("Generation: \(cellModel.counter)").padding(.top)
                HStack(spacing: 10.0, content: {
                    
                    Button("Reset") {
                        self.cellModel.resetGrid()
                    }
                    if self.cellModel.isRunning==true {
                        Button("Stop") {
                            self.cellModel.isRunning=false
                            self.cellModel.counter=0
                            //self.cellModel.step()
                        }
                    } else {
                        Button("Start") {
                            self.cellModel.isRunning=true
                            self.cellModel.step(next: true)
                        }
                    }
                    Button("Step") {
                        self.cellModel.step()
                    }
                })
            }
        }
    }
}
