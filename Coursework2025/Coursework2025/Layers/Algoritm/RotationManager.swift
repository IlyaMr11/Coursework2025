//
//  RotationManager.swift
//  Coursework2025
//
//  Created by Илья Морозов on 03.05.2025.
//

import Foundation

class RotationManager {
  private let shiftLayer = ShiftLayer()
  private let steps: Int
  private var cache: [UUID: [Figure]] = [:]
  
  init(steps: Int) {
    self.steps = steps
  }
  
  func getAllRotations(_ figure: Figure) -> [Figure] {
    let key = figure.id
    
    if let cached = cache[key] {
      return cached
    }
    
    let rotated = (0..<steps).map { step in
      rotate(figure, step: step)
    }
    cache[key] = rotated
    return rotated
  }
  
  func clearCache() {
    cache.removeAll()
  }
  
  private func rotate(_ figure: Figure, step: Int) -> Figure {
    let angle = angleForStep(step)
    let resultFigure = Figure(
      id: figure.id,
      outCircuit: rotateCircuit(figure.outCircuit, angle: angle),
      inCircuit: figure.inCircuit.map { rotateCircuit($0, angle: angle) }
    )
    return shiftLayer.shiftFigure(resultFigure)
  }
  
  private func rotateCircuit(_ circuit: [Point], angle: Double) -> [Point] {
    let radians = angle * .pi / 180
    let cosA = cos(radians)
    let sinA = sin(radians)
    
    return circuit.map { point in
      Point(
        x: point.x * cosA - point.y * sinA,
        y: point.x * sinA + point.y * cosA
      )
    }
  }
  
  private func angleForStep(_ step: Int) -> Double {
    Double(step) * (360.0 / Double(steps))
  }
}
