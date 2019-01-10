//: [Previous](@previous)

import Foundation

var str = "02. Associated value"

let response = """
{
"title": "How to parse JSON in Swift 4",
"series": "Codable share",
"created_by": "roni",
"language": "Swift"
}
"""

enum Language: String, Codable {
    case Swift
    case ObjectiveC
}

struct Event: Codable {
    let title: String
    let series: String
    let createdBy: String
    let language: Language

    enum CodingKeys: String, CodingKey {
        case title
        case series
        case createdBy = "created_by"  // associated value
        case language
    }
}

let data = response.data(using: .utf8)!
let decoder = JSONDecoder()
let event = try! decoder.decode(Event.self, from: data)
dump(event)

enum Keys: String, CaseIterable {
    case title
    case series
    case createdBy
    case language
}

let keys = Keys.allCases.map({ "\($0)"})
dump(keys)



enum AKeys: CaseIterable {
    case title(Int)
    case series
    case createdBy
    case language

    static var allCases: [AKeys] {
        return [title(0), series, createdBy, language]
    }
}

let aKeys = AKeys.allCases.map({ "\($0)"})
dump(aKeys)


//: [Next](@next)
