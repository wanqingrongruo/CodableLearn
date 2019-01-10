import UIKit

var str = "01. Base"

let response = """
{
"title": "How to parse JSON in Swift 4",
"series": "Codable share",
"creator": "roni",
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
    let creator: String
    let language: Language
}

let data = response.data(using: .utf8)!
let decoder = JSONDecoder()
let event = try! decoder.decode(Event.self, from: data)
dump(event)

//: [Next](@next)

