//
//  CellModel.swift
//  GameOfLife
//
//  Created by Mario Rotz on 20.11.23.
//

import SwiftUI

// Zelluläre Automaten-Logik

class CellModel: ObservableObject {
    @Published var playground: Playground
    @Published var counter = 0
    var isRunning : Bool = false

    init(rows: Int, cols: Int) {
        playground = Playground(columns: cols, rows: rows)
        playground.update = {
            [weak self ] in
            self?.objectWillChange.send()
        }
    }
    
    func toggleCell(row: Int, col: Int) {
        self.isRunning=false
        counter = 0
        playground.toggle(at:Position(x: row, y: col))
    }
    
    func resetGrid() {
        playground.reset()
        counter = 0
    }
    
    func step(next:Bool = false) {
        self.playground.nextGeneration()
        self.counter += 1
        if next==true {
            if self.isRunning==true {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    self.step(next: true)
                })
            } else {
                self.counter = 0
            }
        }
    }
}
