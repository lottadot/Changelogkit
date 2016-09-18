//
//  ChangelogAnalyzer.swift
//  ChangelogKit
//
//  Created by Shane Zatezalo on 8/20/16.
//  Copyright © 2016 Lottadot LLC. All rights reserved.
//

import Foundation

/// The `ChangelogAnalyzer is designed to allow easy parsing of a change log file's HEAD. It must be provided the changelog lines, and can optionally be provided Regular Expressions to be used to identify the first line, comment lines and/or ticket lines.
open class ChangelogAnalyzer {
    
    fileprivate var buildDateRegex          = "(?<=)[0-9]{4}-[0-9]{2}-[0-9]{2}"
    
    fileprivate var versionAndBuildRegex    = "^[0-9]+.[0-9]+(.[0-9]+)? #[0-9]"
    internal var firstLineRegex          = "^[0-9]+.[0-9]+(.[0-9]+)? #[0-9]+ [0-9]{4}-[0-9]{2}-[0-9]{2}"
    fileprivate var buildVersionNumberRegex = "^[0-9]+.[0-9]+(.[0-9]+)?"
    fileprivate var buildNumberRegex        = "(?<=#)[0-9]+(?:.*?)" // "#?[0-9]+"
    fileprivate var versionRegex            = "^[0-9]+.[0-9]+(.[0-9]+)?"
    fileprivate var tbdRegex                = "^[0-9]+.[0-9]+(.[0-9]+)? #[0-9]+ TBD$"
    
    internal var commentRegex            = "^(?:-\\s)(.*)$"
    internal var ticketRegex             = "^(?:\\*\\s)(.*)$"

    fileprivate var buildDateFormat         = "YYYY-mm-dd"
    fileprivate var seperatorRegex          = "^$"
    
    fileprivate var lines:[String] = []
    
    public required init(changelog: [String]) {
        self.lines = changelog
    }
    
    /// Create a `ChangeLogAnalyzer` by optionally specifyihng the regex for the first, comment and ticket lines.
    public convenience init(changelog: [String], firstLineRegex: String?, commentRegex: String?, ticketRegex: String?) {
        self.init(changelog: changelog)
        
        if let flr = firstLineRegex {
            self.firstLineRegex = flr
        }

        if let clr = commentRegex {
            self.commentRegex = clr
        }
        
        if let tlr = ticketRegex {
            self.ticketRegex = tlr
        }
    }

    // MARK: - Public functions
    
    /// Provide the Comment Text line(s). Uses `commentRegex` to determine. Nil if none.
    open func comments() -> [String]? {
        return applyToContentLines(commentRegex)
    }
    
    /// Provide the Ticket Text line(s). Uses `ticketRegex` to determine. Nil if none.
    open func tickets() -> [String]? {
        return applyToContentLines(ticketRegex)
    }
    
    open func isTBD() -> Bool {
        return self.hasBuildDateToBeDetermined()
    }
    
    /// Determines the Build Version (ie 1.0) of the latest line of the changelog. Uses `buildVersionNumberRegex` to determine. Nil if none. Note that if the version is x.y.z you should use `buildVersionString`.
    open func buildVersion() -> Double? {
        guard let data = self.applyToFirstLine(buildVersionNumberRegex) as? String, let number:Double = Double.init(data) else {
            return nil
        }
        
        return number
    }
    
    /// Determines the Build Version (ie 1.0, or 1.0.0) of the latest line of the changelog in String Format. Uses `buildVersionNumberRegex` to determine. Nil if none.
    open func buildVersionString() -> String? {
        guard let data = self.applyToFirstLine(buildVersionNumberRegex) as? String else {
            return nil
        }
        
        return data
    }
    
    /// Determines the Build Number (ie 1 or 1000) of the latest line of the changelog. Uses `buildNumberRegex` to determine. Nil if none.
    open func buildNumber() -> UInt? {
        guard let data = self.applyToFirstLine(buildNumberRegex) as? String, let number:UInt = UInt.init(data) else {
            return nil
        }
        
        return number
    }
    
    /// Determines the Build Date (in String format) of the latest line of the changelog. Uses `buildDateRegex` to determine. Nil if none.
    open func buildDateString() -> String? {
        
        guard let data = self.applyToFirstLine(buildDateRegex) as? String else {
            return nil
        }
        
        return data
    }
    
    /// Determines the Build Date (in NSDate format) of the latest line of the changelog. Uses `buildDateFormat` and `buildDateRegex` to determine. Nil if none.
    open func buildDate() -> Date? {
        let stringFormat = buildDateFormat
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = stringFormat
        
        guard let data = self.applyToFirstLine(buildDateRegex) as? String, let date = dateFormatter.date(from: data) else {
            return nil
        }
        
        return date
    }
    
    // MARK: - Private functions
    
    /// Determine whether the first line of the change log has a proper build date. Uses `buildDateRegex`.
    internal func hasBuildDate() -> Bool {
        
        guard let firstLine = lines.first, let _ = firstLine.range(of: buildDateRegex, options: .regularExpression), !lines.isEmpty else {
            return false
        }
        
        return true
    }
    
    /// Determine whether the first line of the change log has a proper build date. Uses `buildDateRegex`.
    internal func hasBuildDateToBeDetermined() -> Bool {
        
        guard let firstLine = lines.first, !lines.isEmpty else {
            return false
        }
        
        return firstLine.contains("TBD")
    }

    /// Determine whether the first line of the change log has a build version number. Uses `buildVersionNumberRegex`.
    internal func hasBuildVersion() -> Bool {
        
        guard let firstLine = lines.first, let _ = firstLine.range(of: buildVersionNumberRegex, options: .regularExpression), !lines.isEmpty else {
            return false
        }
        
        return true
    }
    
    /// Determine whether the first line of the change log has a build number. Uses `buildNumbeRegex`.
    internal func hasBuildNumber() -> Bool {
        
        guard let firstLine = lines.first, let _ = firstLine.range(of: buildNumberRegex, options: .regularExpression) , !lines.isEmpty else {
            return false
        }
        
        return true
    }
    
    /// Apply a regular expression to the first line of the change log.
    fileprivate func applyToFirstLine(_ regex: String) -> AnyObject? {
        
        guard let firstLine = lines.first, let data = firstLine.range(of: regex, options: .regularExpression), !lines.isEmpty else {
            return nil
        }
        
        return firstLine.substring(with: data) as AnyObject?
    }
    
    /// Apply a regular expression to the 3++ line(s) of a change log.
    fileprivate func applyToContentLines(_ regex: String) -> [String]? {
        
        guard  lines.count > 2 else {
            return nil
        }
        
        let regex:NSRegularExpression = try! NSRegularExpression(pattern: regex, options: [])
        var filteredLines:[String] = []
        
        for line in lines {
            
            if let _ = line.range(of: seperatorRegex, options: .regularExpression) {
                break
            }
            
            let nsString = line as NSString
            let results = regex.matches(in: line, options: [], range: NSMakeRange(0, nsString.length))
            if let result = results.first {
                for i in 1..<result.numberOfRanges {
                    filteredLines.append(nsString.substring( with: result.rangeAt(i) ))
                }
            }
            
        }
        return filteredLines
    }
}
