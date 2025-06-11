//
//  CollisionChecker.swift
//  Coursework2025
//
//  Created by Илья Морозов on 04.05.2025.
//

import Foundation

struct CollisionChecker {
  func checkCollision(
    figure: Figure,
    at position: Point,
    placedFigures: [PositionedFigure],
    padding: Double,
    approximator: RectApproximator,
    shiftLayer: ShiftLayer,
    width: Int
  ) -> Bool {
    let rects1 = shiftLayer.shiftApproxime(approximator.approximate(figure: figure), delta: position)
    if !ifAllCoordPositive(shiftLayer.shiftOnDelta(figure, delta: position), width: width) {
      return true
    }
    
    for postionedFigure in placedFigures {
      let rects2 = shiftLayer.shiftApproxime(approximator.approximate(figure: postionedFigure.figure), delta: postionedFigure.origin)
      
      for r1 in rects1 {
        for r2 in rects2 {
          if intersects(r1, r2, padding: padding) {
            return true
          }
        }
      }
    }
    return false
  }
  
  private func intersects(_ first: Rectangle, _ other: Rectangle, padding: Double) -> Bool {
    for p in first.getPoints() {
      if isPointInRect(p, other) {
        return true
      }
    }
    
    for p in other.getPoints() {
      if isPointInRect(p, first) {
        return true
      }
    }
    return false
  }
  
  private func isPointInRect(_ point: Point, _ rect: Rectangle) -> Bool {
    return point.x >= rect.minX && point.x <= rect.maxX && point.y >= rect.minY && point.y <= rect.maxY
  }
  
  private func ifAllCoordPositive(_ figure: Figure, width: Int) -> Bool {
    for p in figure.outCircuit {
      if p.x < 0 || p.y < 0 || Int(p.x) > width {
        return false
      }
    }
    return true
  }
}
