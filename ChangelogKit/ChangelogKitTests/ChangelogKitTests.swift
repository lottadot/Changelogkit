//
//  ChangelogKitTests.swift
//  ChangelogKitTests
//
//  Created by Shane Zatezalo on 8/20/16.
//  Copyright © 2016-2018 Lottadot LLC. All rights reserved.
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
    
    /// Test parsing a changelog file that only has one entry with x.y version
    func testChangelogValidHeaderOnly() {
        let cla = ChangelogAnalyzer(changelog: self.headerOnlyValidLog())
        XCTAssertNotNil(cla)
        
        let version = cla.buildVersion()
        XCTAssertNotNil(version)
		XCTAssertTrue(version == 1.0, "Found version: \(String(describing: version))")
        
        let build = cla.buildNumber()
        XCTAssertNotNil(build)
		XCTAssertTrue(build == 999, "Found build number: \(String(describing: build))")
        
        XCTAssertFalse(cla.isTBD())
        
        let comments = cla.comments()
        XCTAssertNotNil(comments)
        XCTAssertTrue(!(comments?.isEmpty)!)
        XCTAssertTrue(comments?.count == 1, "Found count: \(comments?.count)")
        
        let tickets = cla.tickets()
        XCTAssertNotNil(tickets)
        XCTAssertTrue(!(tickets?.isEmpty)!)
		XCTAssertTrue(tickets?.count == 1, "Found count: \(String(describing: tickets?.count))")
        
        let datestr = cla.buildDateString()
        XCTAssertNotNil(datestr)
        XCTAssertEqual(datestr, "2016-01-01")
        
        XCTAssertTrue(cla.hasBuildVersion())
        XCTAssertTrue(cla.hasBuildNumber())
        XCTAssertTrue(cla.hasBuildDate())
    }
    
    /// Test parsing a changelog file that only has one entry with x.y.z version
    func testChangelogValidLongerVersionHeaderOnly() {
        let cla = ChangelogAnalyzer(changelog: self.headerOnlyVersionThirdDigitValidLog())
        XCTAssertNotNil(cla)
        
        let version = cla.buildVersionString()
        XCTAssertNotNil(version)
		XCTAssertTrue(version == "1.0.0", "Found version: \(version ?? "n/a")")
        
        let build = cla.buildNumber()
        XCTAssertNotNil(build)
		XCTAssertTrue(build == 999, "Found build number: \(String(describing: build))")
        
        XCTAssertFalse(cla.isTBD())
        
        let comments = cla.comments()
        XCTAssertNotNil(comments)
        XCTAssertTrue(!(comments?.isEmpty)!)
        XCTAssertTrue(comments?.count == 1, "Found count: \(comments?.count)")
        
        let tickets = cla.tickets()
        XCTAssertNotNil(tickets)
        XCTAssertTrue(!(tickets?.isEmpty)!)
        XCTAssertTrue(tickets?.count == 1, "Found count: \(tickets?.count)")
        
        let datestr = cla.buildDateString()
        XCTAssertNotNil(datestr)
        XCTAssertEqual(datestr, "2016-01-01")
        
        XCTAssertTrue(cla.hasBuildVersion())
        XCTAssertTrue(cla.hasBuildNumber())
        XCTAssertTrue(cla.hasBuildDate())
    }

    func testChangelogValidMultipleOnly() {
        let cla = ChangelogAnalyzer(changelog: self.multipleReleasesValidLog())
        XCTAssertNotNil(cla)
        
        let version = cla.buildVersion()
        XCTAssertNotNil(version)
        XCTAssertTrue(version == 1.0)
        
        let build = cla.buildNumber()
        XCTAssertNotNil(build)
        XCTAssertTrue(build == 999)
        
        XCTAssertFalse(cla.isTBD())
        
        let comments = cla.comments()
        XCTAssertNotNil(comments)
        XCTAssertTrue(!(comments?.isEmpty)!)
		XCTAssertTrue(comments?.count == 1, "Found count: \(comments?.count ?? 0)")
        
        XCTAssertTrue(comments?.first == "Comment1 Text Misc")
        
        let tickets = cla.tickets()
        XCTAssertNotNil(tickets)
        XCTAssertTrue(!(tickets?.isEmpty)!)
		XCTAssertTrue(tickets?.count == 1, "Found count: \(comments?.count ?? 0)")
        
        XCTAssertTrue(tickets?.first == "TICKETIDENTIFIER1 Jira Ticket Work Description")
        
        let datestr = cla.buildDateString()
        XCTAssertNotNil(datestr)
        XCTAssertEqual(datestr, "2016-01-02")
        
        XCTAssertTrue(cla.hasBuildVersion())
        XCTAssertTrue(cla.hasBuildNumber())
        XCTAssertTrue(cla.hasBuildDate())
    }
    
    func testChangelogValidTBDOnly() {
        let cla = ChangelogAnalyzer(changelog: self.headerOnlyTBDLog())
        XCTAssertNotNil(cla)
        
        let version = cla.buildVersion()
        XCTAssertNotNil(version)
        XCTAssertTrue(version == 1.0)
        
        let build = cla.buildNumber()
        XCTAssertNotNil(build)
        XCTAssertTrue(build == 999)
        
        XCTAssertTrue(cla.isTBD())
    }
    
    // MARK: - Util
    
    func headerOnlyValidLog() -> [String] {
        let log = "1.0 #999 2016-01-01\n====================\n- Comment1 Text Misc\n* TICKETIDENTIFIER1 Jira Ticket Work Description\n\n"
        var lines:[String] = []
        log.enumerateLines {
            line, stop in
            lines.append(line)
        }
        return lines
    }
    
    func headerOnlyVersionThirdDigitValidLog() -> [String] {
        let log = "1.0.0 #999 2016-01-01\n====================\n- Comment1 Text Misc\n* TICKETIDENTIFIER1 Jira Ticket Work Description\n\n"
        var lines:[String] = []
        log.enumerateLines {
            line, stop in
            lines.append(line)
        }

        return lines
    }
    
    func multipleReleasesValidLog() -> [String] {
        let log = "1.0 #999 2016-01-02\n====================\n- Comment1 Text Misc\n* TICKETIDENTIFIER1 Jira Ticket Work Description\n\n1.0 #998 2015-12-30\n====================\n- Comment2 Text Misc\n* TICKETIDENTIFIER2 Jira Ticket Work Description"
        var lines:[String] = []
        log.enumerateLines {
            line, stop in
            lines.append(line)
        }

        return lines
    }
    
    func headerOnlyTBDLog() -> [String] {
        let log = "1.0 #999 2016-TBD\n====================\n- Comment1 Text Misc\n* TICKETIDENTIFIER1 Jira Ticket Work Description\n\n"
        var lines:[String] = []
        log.enumerateLines {
            line, stop in
            lines.append(line)
        }

        return lines
    }
}
