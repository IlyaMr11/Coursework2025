//
//  POint.swift
//  Coursework2025
//
//  Created by Илья Морозов on 24.03.2025.
//

import Foundation


struct Point: Codable {
    let x: Double
    let y: Double
}

extension Point {
  var cgPoint: CGPoint {
    CGPoint(x: CGFloat(x), y: CGFloat(y))
  }
  
  func shiftOn(deltaX: Double, deltaY: Double) -> Point {
    Point(x: x + deltaX, y: y + deltaY)
  }
}
