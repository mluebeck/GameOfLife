//
//  CellModel.swift
//  GameOfLife
//
//  Created by Mario Rotz on 20.11.23.
//

import SwiftUI

// Zelluläre Automaten-Logik

class CellModel: ObservableObject {
    var rows: Int
    var cols: Int
    @Published var grid: [[Bool]]
    
    init(rows: Int, cols: Int) {
        grid = Array(repeating: Array(repeating: false, count: cols), count: rows)
        self.rows = rows
        self.cols = cols
    }
    
    func toggleCell(row: Int, col: Int) {
        grid[row][col].toggle()
    }
    
    func resetGrid() {
        grid = Array(repeating: Array(repeating: false, count: cols), count: rows)
    }
    
    func element(at position:Position) -> Bool? {
        if position.x < 0 || position.y < 0 || position.x>=Int(self.rows) || position.y>=Int(self.cols)
        {
            return nil
        }
        return self.grid[position.x][position.y]
    }
    
    func numberOfNeighbours(at position:Position) -> Int {
        var neighbors : Int = 0
        let indices : [(x:Int,y:Int)] = [(x:0,y:-1),(x:0,y:1),
                                         (x:-1,y:-1),(x:-1,y:1),(x:-1,y:0),
                                         (x:1,y:-1),(x:1,y:1),(x:1,y:0)]
        for index in indices {
            if let v = self.element(at: Position(x: position.x+index.x, y: position.y+index.y)), v == true {
                neighbors += 1
            }
        }
        return neighbors
    }
    
    func step() {
        var localGrid = Array(repeating: Array(repeating: false, count: self.cols), count: self.rows)
        for i in 0..<Int(self.rows) {
            for j in 0..<Int(self.cols) {
                let position = Position(x: i, y: j)
                if let value = self.element(at: position) {
                    let numberOfN = self.numberOfNeighbours(at: Position(x: i, y: j))
                    if value == true {
                        switch numberOfN {
                        case 2,3 :
                            localGrid[i][j] = true
                        default:
                            localGrid[i][j] = false
                        }
                    }
                    else {
                        if numberOfN==3 {
                            localGrid[i][j] = true
                        }
                    }
                }
            }
        }
        self.grid = localGrid
    }
}
