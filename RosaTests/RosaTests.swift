//
//  RosaTests.swift
//  RosaTests
//
//  Created by Chih-Chen Yeh on 2021/6/21.
//

import XCTest
@testable import Rosa

var sut: ChallengeManager!

class RosaTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ChallengeManager()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testChallengeSuccessesWhenProgressReaches30() {
        // given
        let progress = 30
        
        // when
        let result = sut.checkChallengeHasCompleted(progress: progress)
        
        // then
        XCTAssertEqual(result, true, "Challenge did not succeed even the progress reached 30.")
    }
    
    func testChallengeWontSuccessWhenProgressIsUnder30() {
        // given
        let progress = 15
        
        // when
        let result = sut.checkChallengeHasCompleted(progress: progress)
        
        // then
        XCTAssertEqual(result, false, "Challenge successed even the progress hasn't reached 30.")
    }
    
}
