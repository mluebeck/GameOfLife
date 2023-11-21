//
//  GameOfLifeTests.swift
//  GameOfLifeTests
//
//  Created by Mario Rotz on 20.11.23.
//

import XCTest
@testable import GameOfLife

class Playground {
    var array : [[Bool]]
    init(columns:Int,rows:Int) {
        array = Array(repeating: Array(repeating: false, count: rows), count:columns )
    }
    
    var count : Int {
        var counter = 0
        array.forEach {
            element in
            counter += element.count
        }
        return counter
    }
    
    func elementAt(x:Int,y:Int) -> Bool {
        let columns = array[0].count
        let rows = array.count
        var x1 = x
        var y1 = y
        if x1 < 0 { x1 = rows-1}
        if y1 < 0 { y1 = columns-1}
        return array[x1 % rows][y1 % columns]
    }
    
    func set(x:Int,y:Int,value:Bool) {
        let columns = array[0].count
        let rows = array.count
        var x1 = x
        var y1 = y
        if x1 < 0 { x1 = rows-1}
        if y1 < 0 { y1 = columns-1}
        self.array[x1 % rows][y1 % columns] = value
    }
    
    func numberOfNeighbours(x:Int,y:Int)->Int {
        let columns = array[0].count
        let rows = array.count
        var count = 0
        let indices = [(x:-1,y:0),(x:1,y:0),
                       (x:-1,y:1),(x:0,y:1),(x:1,y:1),
                       (x:-1,y:-1),(x:0,y:-1),(x:1,y:-1)]
        indices.forEach{
            index in
            if self.elementAt(x: x+index.x % rows, y: y+index.y % columns) {
                count += 1
            }
        }
        return count
    }
    
    func nextGeneration() {
        let columns = array[0].count
        let rows = array.count
        var newarray = Array(repeating: Array(repeating: false, count: columns), count: rows)
        for x in 0..<rows {
            for y in 0..<columns {
                if self.elementAt(x: x, y: y) == false && self.numberOfNeighbours(x: x, y: y) == 3 {
                    newarray[x % rows][y % columns] = true
                } else
                if self.elementAt(x: x, y: y) == true && self.numberOfNeighbours(x: x, y: y) < 2 {
                    newarray[x % rows][y % columns] = false
                }
                else if self.elementAt(x: x, y: y) == true && (self.numberOfNeighbours(x: x, y: y) == 2 || self.numberOfNeighbours(x: x, y: y) == 3) {
                    newarray[x % rows][y % columns] = true
                }
                else if self.elementAt(x: x, y: y) == true && self.numberOfNeighbours(x: x, y: y) > 3 {
                    newarray[x % rows][y % columns] = false
                }
                else {
                    newarray[x % rows][y % columns] = self.elementAt(x: x, y: y)
                }
            }
        }
        self.array = newarray
    }
}

final class GameOfLifeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

     
    func test_PlaygroundSize()
    {
        let playground = Playground(columns: 10, rows: 20)
        XCTAssertEqual(playground.count,200)
    }
    
    func test_fetchElement() {
        let playground = Playground(columns: 10, rows: 20)
        XCTAssertEqual(playground.elementAt(x:5,y:5),false)
    }
    
    func test_fetchElementOutOfArea() {
        let playground = Playground(columns: 10, rows: 20)
        XCTAssertEqual(playground.elementAt(x:15,y:25),false)
    }
    
    func test_fetchOneTrueElement() {
        let playground = Playground(columns: 10, rows: 20)
        playground.array[5][6] = true
        XCTAssertEqual(playground.elementAt(x:5,y:6),true)
    }
    
    func test_fetchOneOutOfAreaTrueElement() {
        let playground = Playground(columns: 10, rows: 20)
        playground.array[15 % 10][26 % 20] = true
        XCTAssertEqual(playground.elementAt(x:15,y:26),true)
    }
    
    func test_setTrueElementOutOfArea() {
        let playground = Playground(columns: 10, rows: 20)
        playground.set(x:15,y:26,value:true)
        XCTAssertEqual(playground.elementAt(x:15,y:26),true)
    }
    
    func test_setTrueElementOutOfAreaNegative() {
        let playground = Playground(columns: 10, rows: 20)
        playground.set(x:-1,y:-1,value:true)
        XCTAssertEqual(playground.elementAt(x:-1,y:-1),true)
        XCTAssertEqual(playground.elementAt(x:9,y:19),true)
    }
    
    func test_setTrueElement() {
        let playground = Playground(columns: 10, rows: 20)
        playground.set(x:5,y:6,value:true)
        XCTAssertEqual(playground.elementAt(x:5,y:6),true)
    }
    
    func test_hasOneNeighbour() {
        let playground = Playground(columns: 10, rows: 20)
        let origin = (x:5,y:6)
        playground.set(x:origin.x,y:origin.y,value:true)

        playground.set(x:origin.x,y:origin.y-1,value:true)
        //playground.set(x:5,y:7,value:true)

        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),1)
    }
    
   
    func test_has2Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),2)
    }

    func test_has3Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:true)
        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),3)
    }

    func test_has4Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y-1,value:true)
        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),4)
    }
    
    func test_has5Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y-1,value:true)

        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),5)
    }
    
    func test_has6Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y,value:true)

        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),6)
    }
    
    func test_has7Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y,value:true)
        playground.set(x:origin.x+1,y:origin.y+1,value:true)

        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),7)
    }
    
    func test_has8Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y,value:true)
        playground.set(x:origin.x+1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y,value:true)

        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),8)
    }
    
    func test_hasStill8Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y,value:true)
        playground.set(x:origin.x+1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y,value:true)
        
        // Some non-neighbour
        playground.set(x:origin.x+2,y:origin.y,value:true)

        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),8)
    }
    
    func test_rule1_deadCellWith3NeighboursWillBeBorn() {
        let sut = self.putDeadCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y-1,value:false)
        playground.set(x:origin.x+1,y:origin.y-1,value:false)
        playground.set(x:origin.x+1,y:origin.y,value:false)
        playground.set(x:origin.x+1,y:origin.y+1,value:false)
        playground.set(x:origin.x-1,y:origin.y,value:false)
        playground.nextGeneration()
        
        let element = playground.elementAt(x: origin.x, y: origin.y)
        XCTAssertEqual(element, true)
    }
    
    func test_rule1_deadCellWith2NeighboursWillNotBeBorn() {
        let sut = self.putDeadCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:false)
        playground.set(x:origin.x-1,y:origin.y-1,value:false)
        playground.set(x:origin.x+1,y:origin.y-1,value:false)
        playground.set(x:origin.x+1,y:origin.y,value:false)
        playground.set(x:origin.x+1,y:origin.y+1,value:false)
        playground.set(x:origin.x-1,y:origin.y,value:false)
        playground.nextGeneration()
        
        let element = playground.elementAt(x: origin.x, y: origin.y)
        XCTAssertEqual(element, false)
    }
    
    func test_rule1_deadCellWith4NeighboursWillNotBeBorn() {
        let sut = self.putDeadCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y-1,value:false)
        playground.set(x:origin.x+1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y,value:false)
        playground.set(x:origin.x+1,y:origin.y+1,value:false)
        playground.set(x:origin.x-1,y:origin.y,value:false)
        playground.nextGeneration()
        
        let element = playground.elementAt(x: origin.x, y: origin.y)
        XCTAssertEqual(element, false)
    }
    
    func test_rule2_livingCellWithLessThan2NeighboursWillDie() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:false)
        playground.set(x:origin.x-1,y:origin.y+1,value:false)
        playground.set(x:origin.x-1,y:origin.y-1,value:false)
        playground.set(x:origin.x+1,y:origin.y-1,value:false)
        playground.set(x:origin.x+1,y:origin.y,value:false)
        playground.set(x:origin.x+1,y:origin.y+1,value:false)
        playground.set(x:origin.x-1,y:origin.y,value:false)
        playground.nextGeneration()
        
        let element = playground.elementAt(x: origin.x, y: origin.y)
        XCTAssertEqual(element, false)
    }
    
    func test_rule3_livingCellWith2NeighboursKeepsAlive() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:false)
        playground.set(x:origin.x-1,y:origin.y-1,value:false)
        playground.set(x:origin.x+1,y:origin.y-1,value:false)
        playground.set(x:origin.x+1,y:origin.y,value:false)
        playground.set(x:origin.x+1,y:origin.y+1,value:false)
        playground.set(x:origin.x-1,y:origin.y,value:false)
        playground.nextGeneration()
        
        let element = playground.elementAt(x: origin.x, y: origin.y)
        XCTAssertEqual(element, true)
    }
    
    func test_rule3_livingCellWith3NeighboursKeepsAlive() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y-1,value:false)
        playground.set(x:origin.x+1,y:origin.y-1,value:false)
        playground.set(x:origin.x+1,y:origin.y,value:false)
        playground.set(x:origin.x+1,y:origin.y+1,value:false)
        playground.set(x:origin.x-1,y:origin.y,value:false)
        playground.nextGeneration()
        
        let element = playground.elementAt(x: origin.x, y: origin.y)
        XCTAssertEqual(element, true)
    }
    
    func test_rule4_livingCellWith4OrMoreNeighboursDies() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y-1,value:false)
        playground.set(x:origin.x+1,y:origin.y,value:false)
        playground.set(x:origin.x+1,y:origin.y+1,value:false)
        playground.set(x:origin.x-1,y:origin.y,value:false)
        playground.nextGeneration()
        
        let element = playground.elementAt(x: origin.x, y: origin.y)
        XCTAssertEqual(element, false)
    }
    
    func test_rule4_livingCellWithMoreThan4NeighboursDies() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(x:origin.x,y:origin.y-1,value:true)
        playground.set(x:origin.x,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y+1,value:true)
        playground.set(x:origin.x-1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y-1,value:true)
        playground.set(x:origin.x+1,y:origin.y,value:false)
        playground.set(x:origin.x+1,y:origin.y+1,value:false)
        playground.set(x:origin.x-1,y:origin.y,value:false)
        playground.nextGeneration()
        
        let element = playground.elementAt(x: origin.x, y: origin.y)
        XCTAssertEqual(element, false)
    }
    
    //MARK: helper method
    
    func putLivingCellSomewhere() -> ((x:Int,y:Int),Playground) {
        let playground = Playground(columns: 10, rows: 20)
        let origin = (x:3,y:4)
        playground.set(x:origin.x,y:origin.y,value:true)
        return (origin,playground)
    }
    
    func putDeadCellSomewhere() -> ((x:Int,y:Int),Playground) {
        let playground = Playground(columns: 10, rows: 20)
        let origin = (x:13,y:39)
        playground.set(x:origin.x,y:origin.y,value:false)
        return (origin,playground)
    }
    

}
