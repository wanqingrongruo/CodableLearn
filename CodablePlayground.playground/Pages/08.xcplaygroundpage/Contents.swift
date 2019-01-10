//: [Previous](@previous)

import Foundation

var str = "08. 处理常见的 JSON 结构04_更复杂的一般情况"

let response = """
{
    "addition" : {
        "title": "AAAAA",
        "section": "BBBBB"
    },
    "list": [
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
    },
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
    ]
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

struct Addition: Codable {
    let title: String
    let section: String
}

struct Component: Codable {
    let addition: Addition
    let list: [Event]
}

// Decode
let decodeData = response.data(using: .utf8)!
let decoder = JSONDecoder()
decoder.dateDecodingStrategy =  .iso8601
decoder.dataDecodingStrategy = .base64
decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
let list = try! decoder.decode(Component.self, from: decodeData)
dump(list)


//: [Next](@next)
