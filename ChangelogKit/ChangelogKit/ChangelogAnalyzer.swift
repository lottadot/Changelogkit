//
//  ChangelogAnalyzer.swift
//  ChangelogKit
//
//  Created by Shane Zatezalo on 8/20/16.
//  Copyright © 2016 Lottadot LLC. All rights reserved.
//

import Foundation

/// The `ChangelogAnalyzer is designed to allow easy parsing of a change log file's HEAD. It must be provided the changelog lines, and can optionally be provided Regular Expressions to be used to identify the first line, comment lines and/or ticket lines.
public class ChangelogAnalyzer {
    
    private var buildDateRegex          = "(?<=)[0-9]{4}-[0-9]{2}-[0-9]{2}"
    
    private var versionAndBuildRegex    = "^[0-9]+.[0-9]+(.[0-9]+)? #[0-9]"
    internal var firstLineRegex          = "^[0-9]+.[0-9]+(.[0-9]+)? #[0-9]+ [0-9]{4}-[0-9]{2}-[0-9]{2}"
    private var buildVersionNumberRegex = "^[0-9]+.[0-9]+(.[0-9]+)?"
    private var buildNumberRegex        = "(?<=#)[0-9]+(?:.*?)" // "#?[0-9]+"
    private var versionRegex            = "^[0-9]+.[0-9]+(.[0-9]+)?"
    private var tbdRegex                = "^[0-9]+.[0-9]+(.[0-9]+)? #[0-9]+ TBD$"
    
    internal var commentRegex            = "^(?:\\s-\\s)(.*)$"   // "^(?:\\s-\\s).*$"
    internal var ticketRegex             = "^(?:\\s\\*\\s)(.*)$" // "^(?:\\s*\\s).*$"

    private var buildDateFormat         = "YYYY-mm-dd"
    private var seperatorRegex          = "^$"
    
    private var lines:[String] = []
    
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
    public func comments() -> [String]? {
        return applyToContentLines(commentRegex)
    }
    
    /// Provide the Ticket Text line(s). Uses `ticketRegex` to determine. Nil if none.
    public func tickets() -> [String]? {
        return applyToContentLines(ticketRegex)
    }
    
    /// Determines the Build Version (ie 1.0, or 1.0.0) of the latest line of the changelog. Uses `buildVersionNumberRegex` to determine. Nil if none.
    public func buildVersion() -> Double? {
        guard let data = self.applyToFirstLine(buildVersionNumberRegex) as? String, let number:Double = Double.init(data) else {
            return nil
        }
        
        return number
    }
    
    /// Determines the Build Number (ie 1 or 1000) of the latest line of the changelog. Uses `buildNumberRegex` to determine. Nil if none.
    public func buildNumber() -> UInt? {
        guard let data = self.applyToFirstLine(buildNumberRegex) as? String, let number:UInt = UInt.init(data) else {
            return nil
        }
        
        return number
    }
    
    /// Determines the Build Date (in String format) of the latest line of the changelog. Uses `buildDateRegex` to determine. Nil if none.
    public func buildDateString() -> String? {
        
        guard let data = self.applyToFirstLine(buildDateRegex) as? String else {
            return nil
        }
        
        return data
    }
    
    /// Determines the Build Date (in NSDate format) of the latest line of the changelog. Uses `buildDateFormat` and `buildDateRegex` to determine. Nil if none.
    public func buildDate() -> NSDate? {
        let stringFormat = buildDateFormat
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = stringFormat
        
        guard let data = self.applyToFirstLine(buildDateRegex) as? String, let date = dateFormatter.dateFromString(data) else {
            return nil
        }
        
        return date
    }
    
    // MARK: - Private functions
    
    /// Determine whether the first line of the change log has a proper build date. Uses `buildDateRegex`.
    internal func hasBuildDate() -> Bool {
        
        guard let lines:[String] = self.lines where !lines.isEmpty, let firstLine = lines.first, let _ = firstLine.rangeOfString(buildDateRegex, options: .RegularExpressionSearch) else {
            return false
        }
        
        return true
    }

    /// Determine whether the first line of the change log has a build version number. Uses `buildVersionNumberRegex`.
    internal func hasBuildVersion() -> Bool {
        
        guard let lines:[String] = self.lines where !lines.isEmpty, let firstLine = lines.first, let _ = firstLine.rangeOfString(buildVersionNumberRegex, options: .RegularExpressionSearch) else {
            return false
        }
        
        return true
    }
    
    /// Determine whether the first line of the change log has a build number. Uses `buildNumbeRegex`.
    internal func hasBuildNumber() -> Bool {
        
        guard let lines:[String] = self.lines where !lines.isEmpty, let firstLine = lines.first, let _ = firstLine.rangeOfString(buildNumberRegex, options: .RegularExpressionSearch) else {
            return false
        }
        
        return true
    }
    
    /// Apply a regular expression to the first line of the change log.
    private func applyToFirstLine(regex: String) -> AnyObject? {
        
        guard let lines:[String] = self.lines where !lines.isEmpty, let firstLine = lines.first, let data = firstLine.rangeOfString(regex, options: .RegularExpressionSearch) else {
            return nil
        }
        
        return firstLine.substringWithRange(data)
    }
    
    /// Apply a regular expression to the 3++ line(s) of a change log.
    private func applyToContentLines(regex: String) -> [String]? {
        
        guard let regex:NSRegularExpression = try! NSRegularExpression(pattern: regex, options: []), let lines:[String] = self.lines where lines.count > 2 else {
            return nil
        }
        
        var filteredLines:[String] = []
        
        for line in lines {
            
            if let _ = line.rangeOfString(seperatorRegex, options: .RegularExpressionSearch) {
                break
            }
            
            let nsString = line as NSString
            let results = regex.matchesInString(line, options: [], range: NSMakeRange(0, nsString.length))
            if let result = results.first {
                for i in 1..<result.numberOfRanges {
                    filteredLines.append(nsString.substringWithRange( result.rangeAtIndex(i) ))
                }
            }
            
        }
        return filteredLines
    }
}