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
    
    func normalize(columns:Int,rows:Int)->Position {
        var x1 : Int = x
        var y1 : Int = y

        if self.x < 0 {
            x1 = rows+(x % rows)
        } else
        if x>=rows {
            x1 = x % rows
        }
            
        if y < 0 {
            y1 = columns+(y % columns)
        } else
        if y>=columns {
            y1 = y % columns
        }
        return Position(x: x1, y: y1)
    }
}
