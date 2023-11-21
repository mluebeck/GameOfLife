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
    var columns : Int
    var rows : Int
    var update = {}
    init(columns:Int,rows:Int) {
        self.columns = columns
        self.rows = rows
        array = Array(repeating: Array(repeating: false, count: columns), count:rows )
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
        array = Array(repeating: Array(repeating: false, count: self.columns), count:self.rows )
    }
    
    func element(at position:Position) -> Bool {
        let p = position.normalize(columns: columns, rows: rows)
        return self.array[p.x][p.y]
    }
    
    
    func set(position:Position,value:Bool) {
        let p =  position.normalize(columns: columns, rows: rows)
        let x = p.x
        let y = p.y
        if (value == true && self.array[x][y] == false) || (value == false && self.array[x][y] == true){
            toggle(at:Position(x: x, y: y))
        }
    }
    
    func toggle(at position:Position) {
        let p =  position.normalize(columns: columns, rows: rows)
        self.array[p.x][p.y].toggle()
    }
    
    func numberOfNeighbours(x:Int,y:Int)->Int {
         var count = 0
        let indices = [(x:-1,y:0),(x:1,y:0),
                       (x:-1,y:1),(x:0,y:1),(x:1,y:1),
                       (x:-1,y:-1),(x:0,y:-1),(x:1,y:-1)]
        indices.forEach{
            index in
            if self.element(at: Position(x: x+index.x % self.rows, y: y+index.y % self.columns)) {
                count += 1
            }
        }
        return count
    }
    
    func nextGeneration() {
        var newarray = Array(repeating: Array(repeating: false, count: self.columns), count: self.rows)
        for x in 0..<self.rows {
            for y in 0..<self.columns {
                if self.element(at:Position(x: x, y: y)) == false && self.numberOfNeighbours(x: x, y: y) == 3 {
                    newarray[x % self.rows][y % self.columns] = true
                } else
                if self.element(at:Position(x: x, y: y)) == true && self.numberOfNeighbours(x: x, y: y) < 2 {
                    newarray[x % self.rows][y % self.columns] = false
                }
                else if self.element(at:Position(x: x, y: y)) == true && (self.numberOfNeighbours(x: x, y: y) == 2 || self.numberOfNeighbours(x: x, y: y) == 3) {
                    newarray[x % self.rows][y % self.columns] = true
                }
                else if self.element(at:Position(x: x, y: y)) == true && self.numberOfNeighbours(x: x, y: y) > 3 {
                    newarray[x % self.rows][y % self.columns] = false
                }
                else {
                    newarray[x % self.rows][y % self.columns] = self.element(at:Position(x: x, y: y))
                }
            }
        }
        self.array = newarray
    }
}
