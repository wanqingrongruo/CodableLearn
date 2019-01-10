//: [Previous](@previous)

import Foundation

var str = "04. Formatter"

let response = """
{
"title": "How to parse JSON in Swift 4",
"series": "Codable share",
"created_by": "roni",
"language": "Swift",
"created_at": "2019-01-09T10:42:39Z",
"duration": 30,
"nan": "NaN",
"base64": "5pmT6buR5p2/",
"url": "www.xiaoheiban.com"
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
    let createdAt: Date // 时间
    let duration: Float
    let nan: Float
    let base64: Data
    let url: URL

    enum CodingKeys: String, CodingKey {
        case title
        case series
        case createdBy = "created_by"  // associated value
        case language
        case createdAt = "created_at"
        case duration
        case nan
        case base64
        case url
    }
}


// Decode
let decodeData = response.data(using: .utf8)!
let decoder = JSONDecoder()
decoder.dateDecodingStrategy =  .iso8601
decoder.dataDecodingStrategy = .base64
decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
let decodeEvent = try! decoder.decode(Event.self, from: decodeData)
dump(decodeEvent)
print((String(data: decodeEvent.base64, encoding: .utf8)!))


// Encode
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
encoder.dateEncodingStrategy = .iso8601
encoder.dataEncodingStrategy = .base64
encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
let encodeData = try! encoder.encode(decodeEvent)
let eventString = String(data: encodeData, encoding: .utf8)!
print(eventString)

//: [Next](@next)
