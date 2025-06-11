//
//  SimulatedAnnealing.swift
//  Coursework2025
//
//  Created by Илья Морозов on 04.05.2025.
//

import Foundation

class SimulatedAnnealing {
  private let rotationManager = RotationManager(steps: Constants.rotationSteps)
  private let greedyPlacer = GreedyPlacer()
  
  func run(
    _ figures: [Figure],
    sheetWidth: Int,
    padding: Double,
    initialTemp: Double = 1000,
    coolingRate: Double = 0.995,
    iterations: Int = 1000
  ) -> PlacementResult {
    var currentSolution = greedyPlacer.place(figures, sheetWidth: sheetWidth, padding: padding)
    var bestSolution = currentSolution
    
    var temperature = initialTemp
    
    for _ in 0..<iterations where temperature > 1 {
      if let mutated = mutate(currentSolution, sheetWidth: sheetWidth, padding: padding) {
        let delta = mutated.totalHeight - currentSolution.totalHeight
        if delta < 0 || Double.random(in: 0...1) < exp(-delta / temperature) {
          currentSolution = mutated
          if mutated.totalHeight < bestSolution.totalHeight {
            bestSolution = mutated
          }
        }
      }
      temperature *= coolingRate
    }
    
    return bestSolution
  }
  
  private func mutate(_ solution: PlacementResult, sheetWidth: Int, padding: Double) -> PlacementResult? {
    guard !solution.placedFigures.isEmpty else { return nil }
    
    var placedFigures = solution.placedFigures
    let index = Int.random(in: 0..<placedFigures.count)
    let figure = placedFigures[index].figure
    
    let rotations = rotationManager.getAllRotations(figure)
    let rotated = rotations.randomElement()!
    
    if let position = greedyPlacer.findBottomLeftPosition(rotated, placedFigures: placedFigures.filter({ $0.figure.id != figure.id }), sheetWidth: sheetWidth, padding: padding) {
      placedFigures.remove(at: index)
      placedFigures.append(PositionedFigure(figure: rotated, origin: position))
      let totalHeight = greedyPlacer.calculateTotalHeight(placedFigures)
      return PlacementResult(placedFigures: placedFigures, totalHeight: totalHeight)
    }
    
    return nil
  }
}


