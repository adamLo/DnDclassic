//
//  PlayerTests.swift
//  DnDclassicTests
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import XCTest
@testable import DnDclassic

class PlayerTests: XCTestCase {
    
    // MARK: - Luck

    func testLuckPositive() {
        
        let player = Character(isPlayer: true, name: "Test", gender: .other, dexerity: 12, health: 24, luck: 12)
        
        let roll = 2
        
        let result = player.tryLuck(rolled: roll)
        
        XCTAssertEqual(result.rolled, roll)
        XCTAssertTrue(result.success)
        XCTAssertEqual(player.luckCurrent, 11)
    }

    func testLuckNegative() {
        
        let player = Character(isPlayer: true, name: "Test", gender: .other, dexerity: 12, health: 24, luck: 1)
        
        let roll = 24
        
        let result = player.tryLuck(rolled: roll)
        
        XCTAssertEqual(result.rolled, roll)
        XCTAssertFalse(result.success)
        XCTAssertEqual(player.luckCurrent, 0)
    }
    
    // MARK: - Health
    
    func testDamage() {
        
        let player = Character(isPlayer: true, name: "Test", gender: .other, dexerity: 12, health: 24, luck: 12)
        
        player.hitDamage(points: 14)
        XCTAssertEqual(player.healthCurrent, 10)
        
        player.hitDamage(points: 14)
        XCTAssertEqual(player.healthCurrent, 0)
    }
    
    func testEat() {
        
        let player = Character(isPlayer: true, name: "Test", gender: .other, dexerity: 12, health: 24, luck: 12)
        
        player.hitDamage(points: 4)
        XCTAssertEqual(player.healthCurrent, 20)
        
        player.eat()
        XCTAssertEqual(player.healthCurrent, 24)
        XCTAssertEqual(player.food, 9)
        
        player.hitDamage(points: 2)
        XCTAssertEqual(player.healthCurrent, 22)
        
        player.eat()
        XCTAssertEqual(player.healthCurrent, 24)
        XCTAssertEqual(player.food, 8)
    }
}
