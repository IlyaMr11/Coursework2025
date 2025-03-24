//
//  Arc.swift
//  Coursework2025
//
//  Created by Илья Морозов on 24.03.2025.
//

import Foundation


struct Arc: Codable {
    let start: Point
    let end: Point
    let radius: Double
    let center: Point
    let clockwise: Bool
}
