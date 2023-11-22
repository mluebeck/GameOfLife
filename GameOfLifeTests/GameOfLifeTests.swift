//
//  GameOfLifeTests.swift
//  GameOfLifeTests
//
//  Created by Mario Rotz on 20.11.23.
//

import XCTest
@testable import GameOfLife


final class GameOfLifeTests: XCTestCase {

    func test_PlaygroundSize()
    {
        let playground = Playground(columnSize: 10, rowSize: 20)
        XCTAssertEqual(playground.count,200)
    }
    
    func test_fetchElement() {
        let playground = Playground(columnSize: 10, rowSize: 20)
        XCTAssertEqual(playground.element(at:Position(x:5,y:5)),false)
    }
    
    func test_fetchElementOutOfArea() {
        let playground = Playground(columnSize: 10, rowSize: 20)
        XCTAssertEqual(playground.element(at:Position(x:15,y:25)),false)
    }
    
    func test_fetchOneTrueElement() {
        let playground = Playground(columnSize: 10, rowSize: 20)
        playground.array[5][6] = true
        XCTAssertEqual(playground.element(at:Position(x:5,y:6)),true)
    }
    
    func test_fetchOneOutOfAreaTrueElement() {
        let playground = Playground(columnSize: 10, rowSize: 20)
        playground.array[15 % 20][26 % 10] = true
        XCTAssertEqual(playground.element(at:Position(x:15,y:26)),true)
        XCTAssertEqual(playground.element(at:Position(x:15 % 20,y:26 % 10)),true)
    }
    
    func test_setTrueElementOutOfArea() {
        let playground = Playground(columnSize: 10, rowSize: 20)
        playground.set(position:Position(x:15,y:26),value:true)
        XCTAssertEqual(playground.element(at:Position(x:15,y:26)),true)
    }
    
    func test_setTrueElementOutOfAreaNegative() {
        let playground = Playground(columnSize: 10, rowSize: 20)
        playground.set(position:Position(x:-1,y:-1),value:true)
        XCTAssertEqual(playground.element(at:Position(x:-1,y:-1)),true)
        XCTAssertEqual(playground.element(at:Position(x:19,y:9)),true)
    }
    
    func test_setTrueElement() {
        let playground = Playground(columnSize: 10, rowSize: 20)
        playground.set(position:Position(x:5,y:6),value:true)
        XCTAssertEqual(playground.element(at:Position(x:5,y:6)),true)
    }
    
    func test_setToggleElement() {
        let playground = Playground(columnSize: 10, rowSize: 20)
        playground.toggle(at: Position(x:5,y:6))
        XCTAssertEqual(playground.element(at:Position(x:5,y:6)),true)
        playground.toggle(at: Position(x:5,y:6))
        XCTAssertEqual(playground.element(at:Position(x:5,y:6)),false)
        playground.toggle(at: Position(x:5,y:6))
        XCTAssertEqual(playground.element(at:Position(x:5,y:6)),true)
    }
    
    func test_hasOneNeighbour() {
        let playground = Playground(columnSize: 10, rowSize: 20)
        let origin = (x:5,y:6)
        playground.set(position:Position(x:origin.x,y:origin.y),value:true)

        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        //playground.set(x:5,y:7,value:true)

        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),1)
    }
    
   
    func test_has2Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),2)
    }

    func test_has3Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:true)
        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),3)
    }

    func test_has4Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:true)
        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),4)
    }
    
    func test_has5Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:true)

        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),5)
    }
    
    func test_has6Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:true)

        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),6)
    }
    
    func test_has7Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y+1),value:true)

        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),7)
    }
    
    func test_has8Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y),value:true)

        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),8)
    }
    
    func test_hasStill8Neighbours() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y),value:true)
        
        // Some non-neighbour
        playground.set(position:Position(x:origin.x+2,y:origin.y),value:true)

        XCTAssertEqual(playground.numberOfNeighbours(x:origin.x,y:origin.y),8)
    }
    
    //MARK: Rule 1
    func test_rule1_deadCellWith3NeighboursWillBeBorn() {
        let sut = self.putDeadCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y),value:false)
        playground.nextGeneration()
        
        let element = playground.element(at:Position(x: origin.x, y: origin.y))
        XCTAssertEqual(element, true)
    }
    
    func test_rule1_deadCellWith2NeighboursWillNotBeBorn() {
        let sut = self.putDeadCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y),value:false)
        playground.nextGeneration()
        
        let element = playground.element(at:Position(x: origin.x, y: origin.y))
        XCTAssertEqual(element, false)
    }
    
    func test_rule1_deadCellWith1NeighboursWillNotBeBorn() {
        let sut = self.putDeadCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y),value:false)
        playground.nextGeneration()
        
        let element = playground.element(at:Position(x: origin.x, y: origin.y))
        XCTAssertEqual(element, false)
    }
    
    func test_rule1_deadCellWith4NeighboursWillNotBeBorn() {
        let sut = self.putDeadCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y),value:false)
        playground.nextGeneration()
        
        let element = playground.element(at:Position(x: origin.x, y: origin.y))
        XCTAssertEqual(element, false)
    }
    
    //MARK: Rule 2
    func test_rule2_livingCellWithLessThan2NeighboursWillDie() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y),value:false)
        playground.nextGeneration()
        let element = playground.element(at:Position(x: origin.x, y: origin.y))
        XCTAssertEqual(element, false)
    }
    
    //MARK: Rule 3
    func test_rule3_livingCellWith2NeighboursKeepsAlive() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y),value:false)
        playground.nextGeneration()
        
        let element = playground.element(at:Position(x: origin.x, y: origin.y))
        XCTAssertEqual(element, true)
    }
    
    func test_rule3_livingCellWith3NeighboursKeepsAlive() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y),value:false)
        playground.nextGeneration()
        
        let element = playground.element(at:Position(x: origin.x, y: origin.y))
        XCTAssertEqual(element, true)
    }
    
    //MARK: Rule 4
    func test_rule4_livingCellWith4OrMoreNeighboursDies() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y),value:false)
        playground.nextGeneration()
        let element = playground.element(at:Position(x: origin.x, y: origin.y))
        XCTAssertEqual(element, false)
    }
    
    func test_rule4_livingCellWithMoreThan4NeighboursDies() {
        let sut = self.putLivingCellSomewhere()
        let origin = sut.0
        let playground = sut.1
        
        playground.set(position:Position(x:origin.x,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y+1),value:true)
        playground.set(position:Position(x:origin.x-1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y-1),value:true)
        playground.set(position:Position(x:origin.x+1,y:origin.y),value:false)
        playground.set(position:Position(x:origin.x+1,y:origin.y+1),value:false)
        playground.set(position:Position(x:origin.x-1,y:origin.y),value:false)
        playground.nextGeneration()
        let element = playground.element(at:Position(x: origin.x, y: origin.y))
        XCTAssertEqual(element, false)
    }
    
    //MARK: helper method
    
    func putLivingCellSomewhere() -> ((x:Int,y:Int),Playground) {
        let playground = Playground(columnSize: 10, rowSize: 20)
        let origin = (x:Int.random(in: 0...10),y:Int.random(in: 0...20))
        playground.set(position:Position(x:origin.x,y:origin.y),value:true)
        return (origin,playground)
    }
    
    func putDeadCellSomewhere() -> ((x:Int,y:Int),Playground) {
        let playground = Playground(columnSize: 10, rowSize: 20)
        let origin = (x:Int.random(in: 0...10),y:Int.random(in: 0...20))
        playground.set(position:Position(x:origin.x,y:origin.y),value:false)
        return (origin,playground)
    }
    

}
