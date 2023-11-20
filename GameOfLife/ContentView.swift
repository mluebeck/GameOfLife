//
//  ContentView.swift
//  GameOfLife
//
//  Created by Mario Rotz on 19.11.23.
//

import SwiftUI

struct  Position {
    var x : Int
    var y : Int
}

// Zelluläre Automaten-Logik
class CellModel: ObservableObject {
    @Published var grid: [[Bool]]
    
    init(rows: Int, cols: Int) {
        grid = Array(repeating: Array(repeating: false, count: cols), count: rows)
    }
    
    func toggleCell(row: Int, col: Int) {
        grid[row][col].toggle()
    }
    
    func resetGrid() {
        grid = Array(repeating: Array(repeating: false, count: grid[0].count), count: grid.count)
    }
    
    func element(at position:Position) -> Bool? {
        if position.x < 0 || position.y < 0 || position.x>=self.grid.count || position.y>=self.grid.count
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
        var localGrid = Array(repeating: Array(repeating: false, count: grid[0].count), count: grid.count)
        for i in 0..<self.grid[0].count {
            for j in 0..<self.grid[0].count {
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

// SwiftUI-Ansicht für das Spielfeld
struct GameOfLifeView: View {
    @ObservedObject var cellModel: CellModel
    let cellSize: CGFloat = 20.0
    
    var body: some View {
        VStack(spacing:0.0) {
            ForEach(0..<cellModel.grid.count, id: \.self) { row in
                HStack(spacing:0.0) {
                    ForEach(0..<cellModel.grid[row].count, id: \.self) { col in
                        CellView(isAlive: self.$cellModel.grid[row][col])
                            .frame(width: self.cellSize, height: self.cellSize)
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

// SwiftUI-Ansicht für eine einzelne Zelle
struct CellView: View {
    @Binding var isAlive: Bool
    
    var body: some View {
        Rectangle()
            .foregroundColor(isAlive ? .black : .white)
            .border(Color.gray, width: 0.5)
    }
}

struct ContentView: View {
    @StateObject var cellModel = CellModel(rows: 20, cols: 20)
    
    var body: some View {
        GameOfLifeView(cellModel: cellModel)
            .padding()
    }
}



#Preview {
    ContentView()
}
