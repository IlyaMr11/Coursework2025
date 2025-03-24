//
//  Line.swift
//  Coursework2025
//
//  Created by Илья Морозов on 24.03.2025.
//

import Foundation


enum Line: Codable {
    case segment(Segment)
    case arc(Arc)
    
    private enum CodingKeys: String, CodingKey {
        case segment, arc
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let segment = try? container.decode(Segment.self, forKey: .segment) {
            self = .segment(segment)
        } else if let arc = try? container.decode(Arc.self, forKey: .arc) {
            self = .arc(arc)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .segment, in: container, debugDescription: "Invalid line type")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .segment(let segment):
            try container.encode(segment, forKey: .segment)
        case .arc(let arc):
            try container.encode(arc, forKey: .arc)
        }
    }
}
