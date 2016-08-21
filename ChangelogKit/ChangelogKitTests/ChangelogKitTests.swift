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
    
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func headerOnlyValidLog() -> [String] {
        let log = "1.0 #999 2016-01-01\n====================\n - Comment1 Text Misc\n * TICKETIDENTIFIER1 Jira Ticket Work Description\n\n"
        var lines:[String] = []
        log.enumerateLines { lines.append($0.line)}
        return lines
    }
    
    func headerOnlyVersionThirdDigitValidLog() -> [String] {
        let log = "1.0.0 #999 2016-01-01\n====================\n - Comment1 Text Misc\n * TICKETIDENTIFIER1 Jira Ticket Work Description\n\n"
        var lines:[String] = []
        log.enumerateLines { lines.append($0.line)}
        return lines
    }
    
    func multipleReleasesValidLog() -> [String] {
        let log = "1.0 #999 2016-01-02\n====================\n - Comment1 Text Misc\n * TICKETIDENTIFIER1 Jira Ticket Work Description\n\n1.0 #998 2015-12-30\n====================\n - Comment2 Text Misc\n * TICKETIDENTIFIER2 Jira Ticket Work Description"
        var lines:[String] = []
        log.enumerateLines { lines.append($0.line)}
        return lines
    }
    
    func headerOnlyMalformedLog() -> [String] {
        let log = "1.0 #999 2016-01-01\n====================\n - Comment1 Text Misc\n * TICKETIDENTIFIER1 Jira Ticket Work Description\n\n"
        var lines:[String] = []
        log.enumerateLines { lines.append($0.line)}
        return lines
    }
}
