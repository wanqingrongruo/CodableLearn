//: [Previous](@previous)

import Foundation

var str = "16. 补充 JSON 格式"

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

func decode<T>(response: String, of: T.Type) throws where T: Codable {
    let data = response.data(using: .utf8)!
    let decoder = JSONDecoder()
    let model = try decoder.decode(T.self, from: data)

    try encode(of: model)
    dump(model)
}

try decode(response: response, of: Events.self)


//: [Next](@next)
