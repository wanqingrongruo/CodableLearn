//: [Previous](@previous)

import Foundation

var str = "11. 自定义解码"

let response = """
{
"title": "How to parse JSON in Swift 4",
"series": "Codable share",
"language": "Swift",
"created_at": "2019-1-10 15:09:30 +0800",
"nickName": "null",
"array": ["a", "b", "c"]
}
"""

enum Language: String, Codable {
    case Swift
    case ObjectiveC
}

struct Event: Codable {
    let title: String
    let series: String
    let language: Language
    let createdAt: Date // 时间
    let nickName: String?
    let array: [String]

    enum CodingKeys: String, CodingKey {
        case title
        case series
        case language
        case createdAt = "created_at"
        case nickName
        case array
    }

    init(title: String,
         series: String,
         language: Language,
         createdAt: Date,
         nickName: String?,
         array: [String]) {
        self.title = title
        self.series = series
        self.language = language
        self.createdAt = createdAt
        self.nickName = nickName
        self.array = array
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let title = try container.decode(String.self, forKey: .title)
        let series = try container.decode(String.self, forKey: .series)
        let language = try container.decode(Language.self, forKey: .language)
        let createdAt = try container.decode(Date.self, forKey: .createdAt)

        let nickName = try container.decodeIfPresent(String.self, forKey: .nickName)

        var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .array)
        var array = [String]()
        while (!unkeyedContainer.isAtEnd) {
            let item = try unkeyedContainer.decode(String.self)
            array.append(item)
        }

        self.init(title: title, series: series, language: language, createdAt: createdAt, nickName: nickName, array: array)
    }
}

let data = response.data(using: .utf8)!
let decoder = JSONDecoder()
//decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
//    let dateString = try decoder.singleValueContainer().decode(String.self)
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//    return dateFormatter.date(from: dateString)!
//})
let event = try! decoder.decode(Event.self, from: data)
dump(event)



//: [Next](@next)
