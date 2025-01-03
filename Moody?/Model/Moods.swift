//
//  Moods.swift
//  Moody?
//
//  Created by Jack Herrmann on 24.02.21.
//

import Foundation
import SwiftUI

public struct CodableColor: Equatable, Hashable {

    let color: Color
}

extension CodableColor: Encodable {

    public func encode(to encoder: Encoder) throws {
        let nsCoder = NSKeyedArchiver(requiringSecureCoding: true)
        UIColor(color).encode(with: nsCoder)
        var container = encoder.unkeyedContainer()
        try container.encode(nsCoder.encodedData)
    }
}

extension CodableColor: Decodable {

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let decodedData = try container.decode(Data.self)
        let nsCoder = try NSKeyedUnarchiver(forReadingFrom: decodedData)

        guard let color = UIColor(coder: nsCoder) else {
            struct UnexpectedlyFoundNilError: Error {}
            throw UnexpectedlyFoundNilError()
        }
        self.color = Color(color)
    }
}

public extension Color {
    func codable() -> CodableColor {
        return CodableColor(color: self)
    }
}

struct Mood: Hashable, Identifiable, Codable {
    
    var id = UUID().uuidString
    var name: String
    var associatedColor: CodableColor
}

struct myMood: Identifiable, Hashable, Codable {
    
    var id = UUID().uuidString
    var name: String
    var img: String
}
