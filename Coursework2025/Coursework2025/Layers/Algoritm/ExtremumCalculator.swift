//
//  ExtremumCalculator.swift
//  Coursework2025
//
//  Created by Илья Морозов on 03.05.2025.
//

import Foundation


class ExtremumCalculator {
  static func figureExtremum(_ figure: Figure) -> (minX: Double, maxX: Double, minY: Double, maxY: Double) {
    var minX: Double = Double.greatestFiniteMagnitude
    var maxX: Double = -Double.greatestFiniteMagnitude
    var minY: Double = Double.greatestFiniteMagnitude
    var maxY: Double = -Double.greatestFiniteMagnitude
    
    for point in figure.outCircuit {
      minX = min(point.x, minX)
      maxX = max(point.x, maxX)
      minY = min(point.y, minY)
      maxY = max(point.y, maxY)
    }
    
    return (minX, maxX, minY, maxY)
  }
}
