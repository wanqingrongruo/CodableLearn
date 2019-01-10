//: [Previous](@previous)

import Foundation

var str = "12. 扁平化嵌套的字段"

let response = """
{
    "title": "How to parse JSON in Swift 4",
    "series": "Codable share",
    "language": "Swift",
    "created_at": "2019-1-10 15:09:30 +0800",
    "child": {
        "nickName": "mars"
    }
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
    let createdAt: Date
    let nickName: String

    enum CodingKeys: String, CodingKey {
        case title
        case series
        case language
        case createdAt = "created_at"  // associated value
        case child
    }

    enum ChildCodingKeys: String, CodingKey {
        case nickName
    }

    init(title: String,
         series: String,
         language: Language,
         createdAt: Date,
         nickName: String) {
        self.title = title
        self.series = series
        self.language = language
        self.createdAt = createdAt
        self.nickName = nickName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let title = try container.decode(String.self, forKey: .title)
        let series = try container.decode(String.self, forKey: .series)
        let language = try container.decode(Language.self, forKey: .language)
        let createdAt = try container.decode(Date.self, forKey: .createdAt)

        let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .child)
        let nickName = try childContainer.decode(String.self, forKey: .nickName)
        self.init(title: title, series: series, language: language, createdAt: createdAt, nickName: nickName)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(series, forKey: .series)
        try container.encode(language, forKey: .language)
        try container.encode(createdAt, forKey: .createdAt)

        var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .child)
        try childContainer.encode(nickName, forKey: .nickName)
    }
}

let data = response.data(using: .utf8)!
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
    let dateString = try decoder.singleValueContainer().decode(String.self)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    return dateFormatter.date(from: dateString)!
})
let event = try! decoder.decode(Event.self, from: data)
dump(event)

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
encoder.dateEncodingStrategy = .custom({ (date, encoder) in
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    let string = formatter.string(from: date)
    var singleValueContainer = encoder.singleValueContainer()
    try singleValueContainer.encode(string)
})
let dataEN = try! encoder.encode(event)
print(String(data: dataEN, encoding: .utf8)!)


//: [Next](@next)
