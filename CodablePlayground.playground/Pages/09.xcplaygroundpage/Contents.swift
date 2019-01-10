//: [Previous](@previous)

import Foundation

var str = "09. 自定义编码过程"

/* Content:
 * 1. 默认容器
 * 2. SingleValueContainer
 * 3. optional 类型编码: encodeIfPresent
 */


struct Event: Codable {
    let title: String
    let createdAt: Date
    let nickName: String?

    enum CodingKeys: String, CodingKey {
        case title
        case createdAt = "created_at"  // associated value
        case nickName
    }
}

extension Event {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(nickName, forKey: .nickName)
    }
}

//let event = Event(title: "MMP", createdAt: Date())
let event = Event(title: "MMP", createdAt: Date(), nickName: nil)


let encoder = JSONEncoder()
encoder.dateEncodingStrategy = .custom({ (date, encoder) in
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    let string = formatter.string(from: date)
    var singleValueContainer = encoder.singleValueContainer()
    try singleValueContainer.encode(string)
})
let data = try! encoder.encode(event)
print(String(data: data, encoding: .utf8)!)


//: [Next](@next)
