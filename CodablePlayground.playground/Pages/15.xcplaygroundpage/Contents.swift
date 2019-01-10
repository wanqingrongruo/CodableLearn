//: [Previous](@previous)

import Foundation

var str = "15. 版本兼容"

struct Event: Codable {
    let createdAt: Date // 时间


    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let options =
            encoder.userInfo[EventCodingOptions.infoKey] as?
            EventCodingOptions {
            let date = options.dateFormatter.string(from: createdAt)
            try! container.encode(date, forKey: .createdAt)
        }
    }

    init(createdAt: Date) {
        self.createdAt = createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.init(createdAt: createdAt)
    }
}

struct EventCodingOptions {
    enum Version {
        case v1
        case v2
    }

    let appVersion: Version
    let dateFormatter:DateFormatter

    static let infoKey = CodingUserInfoKey(rawValue: "event options")!
}

func encode<T>(of model: T, options: [CodingUserInfoKey: Any]?) throws where T: Codable {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    if let options = options {
        encoder.userInfo = options
    }

    let data = try encoder.encode(model)
    print(String(data: data, encoding: .utf8)!)
}

let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
let option = EventCodingOptions(appVersion: .v1, dateFormatter: formatter)

let formatterV2 = DateFormatter()
formatterV2.dateFormat = "yyyy-MM-dd"
let optionV2 = EventCodingOptions(appVersion: .v2, dateFormatter: formatterV2)

let event = Event(createdAt: Date())
try encode(of: event, options: [EventCodingOptions.infoKey: option])
try encode(of: event, options: [EventCodingOptions.infoKey: optionV2])


let response = """
{
    "created_at": "2019-01-10 17:51:57 +0800"
}
"""
let data = response.data(using: .utf8)!
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
    let dateString = try decoder.singleValueContainer().decode(String.self)
    if let options = decoder.userInfo[EventCodingOptions.infoKey] as?
        EventCodingOptions {
         return options.dateFormatter.date(from: dateString)!
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.date(from: dateString)!
    }
})

decoder.userInfo = [EventCodingOptions.infoKey: option]
let decodeEvent = try! decoder.decode(Event.self, from: data)
dump(decodeEvent)

//decoder.userInfo = [EventCodingOptions.infoKey: optionV2]
//let decodeEvent02 = try! decoder.decode(Event.self, from: data)
//dump(decodeEvent02)


//: [Next](@next)
