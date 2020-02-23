//
//  FightTests.swift
//  DnDclassicTests
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import XCTest
@testable import DnDclassic

class FightTests: XCTestCase {

    func testPlayerWins() {
        
        let player = Player(isPlayer: true, name: "Player", gender: .other, dexerity: 12, health: 24, luck: 12)
        let opponent = Player(isPlayer: false, name: "Opponent", gender: .other, dexerity: 7, health: 4, luck: 7)
        
        let fight = Fight(player: player, opponent: opponent)
        
        let result1 = fight.performRound(playerRoll: 12, opponentRoll: 2)
        XCTAssertEqual(result1.playerHit, 2)
        XCTAssertEqual(result1.opponentHit, 0)
        XCTAssertEqual(player.healthCurrent, 24)
        XCTAssertEqual(opponent.healthCurrent, 2)
        XCTAssertFalse(fight.isFinished)
        
        let result2 = fight.performRound(playerRoll: 12, opponentRoll: 2)
        XCTAssertEqual(result2.playerHit, 2)
        XCTAssertEqual(result2.opponentHit, 0)
        XCTAssertEqual(player.healthCurrent, 24)
        XCTAssertEqual(opponent.healthCurrent, 0)
        XCTAssertTrue(fight.isFinished)
        XCTAssertTrue(fight.hasUserWon)
    }

}
