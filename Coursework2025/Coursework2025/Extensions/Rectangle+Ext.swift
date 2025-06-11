//
//  Rectangle+Ext.swift
//  Coursework2025
//
//  Created by Илья Морозов on 04.05.2025.
//

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
