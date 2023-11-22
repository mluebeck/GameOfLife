//
//  Position.swift
//  GameOfLife
//
//  Created by Mario Rotz on 20.11.23.
//

import Foundation


struct Position {
    var x : Int
    var y : Int
    
    func normalize(columnSize:Int,rowSize:Int)->Position {
        var x1 : Int = x
        var y1 : Int = y

        if self.x < 0 {
            x1 = rowSize+(x % rowSize)
        } else
        if x>=rowSize {
            x1 = x % rowSize
        }
            
        if y < 0 {
            y1 = columnSize+(y % columnSize)
        } else
        if y>=columnSize {
            y1 = y % columnSize
        }
        return Position(x: x1, y: y1)
    }
}
