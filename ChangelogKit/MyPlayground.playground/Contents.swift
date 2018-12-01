//: Playground - noun: a place where people can play

import Cocoa
import ChangelogKit

var log = "1.0 #999 2016-01-01\n====================\n - Comment1 Text Misc\n * TICKETIDENTIFIER Jira Ticket Work Description\n\n"
var lines:[String] = []
log.enumerateLines { lines.append($0.line)}

extension String {
    
    func split(regex pattern: String) -> [String] {
        
        guard let re = try? NSRegularExpression(pattern: pattern, options: [])
            else { return [] }
        
        let nsString = self as NSString // needed for range compatibility
        let stop = "<SomeStringThatYouDoNotExpectToOccurInSelf>"
        let modifiedString = re.stringByReplacingMatchesInString(
            self,
            options: [],
            range: NSRange(location: 0, length: nsString.length),
            withTemplate: stop)
        return modifiedString.componentsSeparatedByString(stop)
    }
}


func matches(for regex: String!, in text: String!) -> [String] {
    
    do {
        let regex = try NSRegularExpression(pattern: regex, options: [])
        let nsString = text as NSString
        let results = regex.matchesInString(text, options: [], range: NSMakeRange(0, nsString.length))
        var match = [String]()
        for result in results {
            for i in 1..<result.numberOfRanges {
                match.append(nsString.substringWithRange( result.rangeAtIndex(i) ))
            }
        }
        return match
        //return results.map { nsString.substringWithRange( $0.range )} //rangeAtIndex(0)
    } catch let error as NSError {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

func applyToFirstLine(regex: String) -> AnyObject? {
    
    guard let lines:[String] = lines where !lines.isEmpty, let firstLine = lines.first, let data = firstLine.rangeOfString(regex, options: .RegularExpressionSearch) else {
        return nil
    }
    
    return firstLine.substringWithRange(data)
}

func applyTo(regex: String, line: String) -> AnyObject? {
	
	guard let data = line.range(of: regex, options: .regularExpression, range: nil, locale: nil) else {
		return nil
	}

	//return line.substring(with: data) as AnyObject
	return line[data] as AnyObject
}

//
//
//
////let strings = split(log) {$0 == "\n"}
//let strings = log.characters.split{$0 == "\n"}.map(String.init)
//print(strings)
//
//let strings2 = log.componentsSeparatedByString("\n")
//print(strings2)
//
//let ticketLines = log.split(regex: "/^ \\* (?<issueid>.+)$/")
//print(ticketLines)
//print(ticketLines[0])
//
//var lines:[String] = []
//log.enumerateLines { lines.append($0.line)}
//print(lines)
//
//if let firstLine = lines.first {
//    if let match = firstLine.rangeOfString("$TBD", options: .RegularExpressionSearch) {
//        print("Probably TBD")
//    } else {
//        print("Probably a BUILD")
//    }
//}
//
//if let firstLine = lines.first {
//    if let match = firstLine.rangeOfString("^[0-9]+.[0-9]+(.[0-9]+)? #[0-9]+ [0-9]{4}-[0-9]{2}-[0-9]{2}", options: .RegularExpressionSearch) {
//        print("Versioned BUILD: match:\(match)")
//    }
//}
//
//if let firstLine = lines.first {
//    if let buildNumber = firstLine.rangeOfString("(?<=#)[0-9]+", options: .RegularExpressionSearch) {
//        print("Versioned BUILD: buildNumber:\(firstLine.substringWithRange(buildNumber))")
//    }
//}
//
//
//let cla = ChangelogAnalyzer.init(changelog: lines)
//if let build = cla.buildNumber() {
//    print("build number: __\(build)__")
//}
//if let version = cla.buildVersion() {
//    print("build version: __\(version)__")
//}
//
//var buildNumberRegex = "(?<=#)[0-9]+(?:.*?)" // "#?[0-9]+"
//if let a = applyToFirstLine(buildNumberRegex) as? String, let b = UInt.init(a) {
//    print("a: \(a) b:\(b)")
//}
//if let rawBN = applyToFirstLine(buildNumberRegex) as? String {
//    print(rawBN.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
//    print(rawBN.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
//    
//    print(rawBN.stringByReplacingOccurrencesOfString("\n", withString: "", options: [], range: nil))
//    
////    if (rawBN.contains("\n")) {
////        print("has N")
////    }
//    
//    if let bn:UInt = UInt.init(rawBN) {
//     print("bn: __\(bn)__")
//    }
//}
//
//var buildDateRegex = "(?<=)[0-9]{4}-[0-9]{2}-[0-9]{2}"
//if let a = applyToFirstLine(buildDateRegex) as? String {
//    print("a: __\(a)__")
//}
//if let a:String = cla.buildDate() {
//    print("a: __\(a)__")
//}
//if let a:NSDate = cla.buildDate() {
//    print("a: __\(a)__")
//}
//
//var commentRegex = "^ - .*?"
//private var ticketRegex = "^ * (?<issueid>.+)$"
//
//if let a:[String] = cla.comments() {
//    print("a: __\(a)__")
//    for aa in a {
//        print("__\(aa)__")
//    }
//}
//
//if let b:[String] = cla.tickets() {
//    print("b: __\(b)__")
//    for bb in b {
//        print("__\(bb)__")
//    }
//}
//
//
//if let res = applyTo("^\\s-\\s(.*)$" , line: " - comment blah blah\n") {
//    print("__\(res)__")
//} // ^(?:\\s*\\s).*$
//if let res = applyTo("^(?:\\s\\*\\s)(.*)$" , line: " * TICKET This is a ticket\n") {
//    print("__\(res)__")
//}
//
//print ( matches(for: "^(?:\\s-\\s)(.*)$" , in: " - COMET This is a ticket"))
//print ( matches(for: "^(?:\\s\\*\\s)(.*)$" , in: " * TICKET This is a ticket"))
//
//let f =  matches(for: "^(?:\\s\\*\\s)(.*)$" , in: " * TICKET This is a ticket")
//print(f)
//
//let text = " * TICKET This is a ticket"
//let nsString = text as NSString
//let pattern = "^(?:\\s\\*\\s)(.*)$"
//let regex = try NSRegularExpression(pattern: pattern, options: [])
//let results = regex.matchesInString(text, options: [], range: NSMakeRange(0, nsString.length))
//print(results.count)
////for result in results {
//if let result = results.first {
//    for i in 1..<result.numberOfRanges {
//        print(nsString.substringWithRange( result.rangeAtIndex(i) ))
//    }
//}

let sep = "^$"
print ( matches(for: "^(?:\\s-\\s)(.*)$" , in: " - COMET This is a ticket"))
print ( matches(for: "^(\\d+\\.)?(\\d+\\.)?(\\*|\\d+)", in: "1.0.0 #999"))
//print ( matches(for: "^(\\d+.)?(\\d+.)?(\\*|\\d+) ", in: "1.0 #999"))
print ( matches(for: "^\\d+\\.\\d+\\.?\\*|\\d+", in: "1.0.0 #999"))
print ( matches(for: "^\\d+\\.\\d+\\.?\\*|\\d+", in: "1.0 #999"))
//[0-9]+
print ( matches(for: "^([0-9]+.[0-9]+.?[0-9]+)", in: "1.0.0 #999"))
print ( matches(for: "^(\\d+)(?:\\.(\\d+))?(?:\\.(\\d+))?(?:\\.)?$", in: "1.0.0 #999"))
print ( matches(for: "^([0-9].[0-9].?[0-9]?)", in: "1.0 #999"))
print ( matches(for: "^([0-9].[0-9].?[0-9]?)", in: "1.0.0 #999"))

print ( matches(for: "TBD", in: "1.0.0 #999 2016-01-TBD"))
//print( "TBD".containsString("TBD"))



