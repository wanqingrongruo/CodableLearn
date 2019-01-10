//: [Previous](@previous)

import Foundation

var str = "13. 有继承关系的 model 的编码解码"

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
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
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

// ???: 默认 Codable 中的默认 encode 方法并不能正确处理派生类对象

//: [Next](@next)
