//
//  File.swift
//  Coursework2025
//
//  Created by Илья Морозов on 24.03.2025.
//

import Foundation

struct Figure: Codable {
  let id: UUID
  let outCircuit: [Point]
  let inCircuit: [Point]?
  
  init(id: UUID, outCircuit: [Point], inCircuit: [Point]? = nil) {
    self.id = UUID()
    self.outCircuit = outCircuit
    self.inCircuit = inCircuit
  }
}

extension Figure {
  func scaleFigure(scale: Double) -> Figure {
    let scaleOutCircuits: [Point] = outCircuit.map { p in
      Point(x: p.x * scale, y: p.y * scale)
    }
    
    guard let inCircuit else {
      return Figure(id: id, outCircuit: scaleOutCircuits)
    }
    let scaleInCircuits = inCircuit.map { p in
      Point(x: p.x * scale, y: p.y * scale)
    }
    
    return Figure(id: id, outCircuit: scaleOutCircuits, inCircuit: scaleInCircuits)
  }
}
