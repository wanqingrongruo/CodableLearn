//: [Previous](@previous)

import Foundation

var str = "14. 改写13"

class P2D: Codable {
    var x: Double = 0
    var y: Double = 0

    // private
    private enum CodingKeys: String, CodingKey{
        case x
        case y
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
}

class P3D: P2D {
    var z: Double = 0

    private enum CodingKeys: String, CodingKey{
        case z
//        case p2d
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: container.superEncoder())
//        try super.encode(to: container.superEncoder(forKey: .p2d))
        try container.encode(z, forKey: .z)
    }
}

func encode<T>(of model: T) throws where T: Codable {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    let data = try encoder.encode(model)
    print(String(data: data, encoding: .utf8)!)
}

var p31 = P3D()
p31.x = 1
p31.y = 2
p31.z = 3

try encode(of: p31)

//: [Next](@next)
