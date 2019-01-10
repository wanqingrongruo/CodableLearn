//: [Previous](@previous)

import Foundation

import Foundation

var str = "10. 自定义编码中的数组"

struct Event: Codable {
    let title: String
    let createdAt: Date
    let nickName: String?
    let array: [String] = ["a", "b", "c"]

    enum CodingKeys: String, CodingKey {
        case title
        case createdAt = "created_at"  // associated value
        case nickName
        case array
    }
}

extension Event {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(nickName, forKey: .nickName)

        var unKeyedContainer = container.nestedUnkeyedContainer(forKey: .array)
        try array.forEach({
            try unKeyedContainer.encode($0)
        })
    }
}

let event = Event(title: "MMP", createdAt: Date(), nickName: nil)


let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
//encoder.dateEncodingStrategy = .custom({ (date, encoder) in
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
//    let string = formatter.string(from: date)
//    var singleValueContainer = encoder.singleValueContainer()
//    try singleValueContainer.encode(string)
//})
let data = try! encoder.encode(event)
print(String(data: data, encoding: .utf8)!)


//struct Demo: Codable {
//    let array: [String] = ["a", "b", "c"]
//
//    func encode(to encoder: Encoder) throws {
//        var unKeyedContainer = encoder.unkeyedContainer()
//        try array.forEach({
//            try unKeyedContainer.encode($0)
//        })
//    }
//}
//
//
//let encoder = JSONEncoder()
//encoder.outputFormatting = .prettyPrinted
//let data = try! encoder.encode(Demo())
//print(String(data: data, encoding: .utf8)!)


//: [Next](@next)
