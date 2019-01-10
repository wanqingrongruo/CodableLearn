//: [Previous](@previous)

import Foundation

var str = "17. 错误处理"

let response = """
{
"1":{
"title": " title 1"
},
"2": {
"title": "title 2"
},
"3": {
"title": "title 3"
}
"""

struct Events: Codable {

    var events: [Event] = []

    struct Event: Codable {
        let id: Int
        let title: String
    }

    struct Info: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }

        static let title = Info(stringValue: "title")!
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: Info.self)

        var v = [Event]()
        for key in container.allKeys {
            let innerContainer = try container.nestedContainer(
                keyedBy: Info.self, forKey: key)

            let title = try innerContainer.decode(
                String.self, forKey: .title)
            let event = Event(id: Int(key.stringValue)!, title: title)

            v.append(event)
        }

        self.events = v
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(
            keyedBy: Info.self)

        for event in events {
            let id = Info(
                stringValue: String(event.id))!

            // id 一定是 Info 中存在的 key ? => valueNotFound
            var nested = container.nestedContainer(
                keyedBy: Info.self, forKey: id)

            try nested.encode(event.title, forKey: .title)
        }
    }
}

func encode<T>(of model: T) throws where T: Codable {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    let data = try encoder.encode(model)
    print(String(data: data, encoding: .utf8)!)
}

func decode<T>(response: String, of: T.Type) throws -> T where T: Codable {
    let data = response.data(using: .utf8)!
    let decoder = JSONDecoder()

    do {
        let model = try decoder.decode(T.self, from: data)
        return model
    } catch DecodingError.typeMismatch(let type, let context) {
        dump(type)
        dump(context)
        exit(-1)
    }


}

let event = try decode(response: response, of: Events.self)

try encode(of: event)

/*
 * DecodingError: typeMismatch, valueNotFound
 * EncodingError
 */

//: [Next](@next)
