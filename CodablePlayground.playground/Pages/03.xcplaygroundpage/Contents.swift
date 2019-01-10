//: [Previous](@previous)

import Foundation

var str = "03. Encode"

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

let event = Event(title: "How to parse JSON in Swift 4", series: "Codable share", createdBy: "roni", language: .Swift)
let encoder = JSONEncoder()
// encoder.outputFormatting = .prettyPrinted
let data = try! encoder.encode(event)
let eventString = String(data: data, encoding: .utf8)!
print(eventString)

//: [Next](@next)
