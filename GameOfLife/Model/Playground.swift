//
//  Playground.swift
//  GameOfLife
//
//  Created by Mario Rotz on 21.11.23.
//

import Foundation

 
public class Playground    {
    var array : [[Bool]] {
        didSet {
            self.update()
        }
    }
    var columnSize : Int
    var rowSize : Int
    var update = {}
    init(columnSize:Int,rowSize:Int) {
        self.columnSize = columnSize
        self.rowSize = rowSize
        array = Array(repeating: Array(repeating: false, count: columnSize), count:rowSize )
    }
    
    var count : Int {
        var counter = 0
        array.forEach {
            element in
            counter += element.count
        }
        return counter
    }
    
    func reset() {
        array = Array(repeating: Array(repeating: false, count: self.columnSize), count:self.rowSize )
    }
    
    func element(at position:Position) -> Bool {
        let p = position.normalize(columnSize: columnSize, rowSize: rowSize)
        return self.array[p.x][p.y]
    }
    
    
    func set(position:Position,value:Bool) {
        let p =  position.normalize(columnSize: columnSize, rowSize: rowSize)
        let x = p.x
        let y = p.y
        if (value == true && self.array[x][y] == false) || (value == false && self.array[x][y] == true){
            toggle(at:Position(x: x, y: y))
        }
    }
    
    func toggle(at position:Position) {
        let p =  position.normalize(columnSize: columnSize, rowSize: rowSize)
        self.array[p.x][p.y].toggle()
    }
    
    func numberOfNeighbours(x:Int,y:Int)->Int {
         var count = 0
        let indices = [(x:-1,y:0),(x:1,y:0),
                       (x:-1,y:1),(x:0,y:1),(x:1,y:1),
                       (x:-1,y:-1),(x:0,y:-1),(x:1,y:-1)]
        indices.forEach{
            index in
            if self.element(at: Position(x: x+index.x % self.rowSize, y: y+index.y % self.columnSize)) {
                count += 1
            }
        }
        return count
    }
    
    func nextGeneration() {
        var newarray = Array(repeating: Array(repeating: false, count: self.columnSize), count: self.rowSize)
        for x in 0..<self.rowSize {
            for y in 0..<self.columnSize {
                let neighbours = self.numberOfNeighbours(x: x, y: y)
                switch self.element(at:Position(x: x, y: y))
                {
                case false:
                    switch neighbours {
                    case 3:
                        newarray[x % self.rowSize][y % self.columnSize] = true
                    default:
                        newarray[x % self.rowSize][y % self.columnSize] = self.element(at:Position(x: x, y: y))
                    }
                default:
                    switch neighbours {
                    case 2,3:
                        newarray[x % self.rowSize][y % self.columnSize] = true
                    default:
                        newarray[x % self.rowSize][y % self.columnSize] = false
                    }
                }
            }
        }
        self.array = newarray
    }
}
