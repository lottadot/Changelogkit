//
//  ChangelogKitTests.swift
//  ChangelogKitTests
//
//  Created by Shane Zatezalo on 8/20/16.
//  Copyright © 2016 Lottadot LLC. All rights reserved.
//

import XCTest
@testable import ChangelogKit

class ChangelogKitTests: XCTestCase {

    /// Test the convenience initializer
    func testConvenienceInit() {
        var cla = ChangelogAnalyzer(changelog: self.headerOnlyValidLog(), firstLineRegex: nil, commentRegex: nil, ticketRegex: nil)
        XCTAssertNotNil(cla)
        XCTAssertNotNil(cla.firstLineRegex)
        XCTAssertNotNil(cla.commentRegex)
        XCTAssertNotNil(cla.ticketRegex)
        
        cla = ChangelogAnalyzer(changelog: self.headerOnlyValidLog(), firstLineRegex: "foo", commentRegex: nil, ticketRegex: nil)
        XCTAssertNotNil(cla)
        XCTAssertNotNil(cla.firstLineRegex)
        XCTAssertNotNil(cla.commentRegex)
        XCTAssertNotNil(cla.ticketRegex)
        XCTAssertEqual(cla.firstLineRegex, "foo")
        
        cla = ChangelogAnalyzer(changelog: self.headerOnlyValidLog(), firstLineRegex: "foo", commentRegex: "bar", ticketRegex: nil)
        XCTAssertNotNil(cla)
        XCTAssertNotNil(cla.firstLineRegex)
        XCTAssertNotNil(cla.commentRegex)
        XCTAssertNotNil(cla.ticketRegex)
        XCTAssertEqual(cla.commentRegex, "bar")
        
        cla = ChangelogAnalyzer(changelog: self.headerOnlyValidLog(), firstLineRegex: "foo", commentRegex: "bar", ticketRegex: "car")
        XCTAssertNotNil(cla)
        XCTAssertNotNil(cla.firstLineRegex)
        XCTAssertNotNil(cla.commentRegex)
        XCTAssertNotNil(cla.ticketRegex)
        XCTAssertEqual(cla.ticketRegex, "car")
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
