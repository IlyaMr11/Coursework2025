//
//  Rectangle.swift
//  Coursework2025
//
//  Created by Илья Морозов on 02.05.2025.
//

import Foundation

struct Rectangle {
    let minX: Double
    let maxX: Double
    let minY: Double
    let maxY: Double
}

extension Rectangle {
  func getPoints() -> [Point] {
    [
      .init(x: minX, y: minY),
      .init(x: maxX, y: minY),
      .init(x: maxX, y: maxY),
      .init(x: minX, y: maxY),
      .init(x: minX, y: minY)
    ]
  }
}
