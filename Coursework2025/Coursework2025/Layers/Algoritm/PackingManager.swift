//
//  PackingAlgoritm.swift
//  Coursework2025
//
//  Created by Илья Морозов on 04.05.2025.
//

import Foundation

class PackingManager {
  private let geneticAlg = GeneticAlgorithm()
  private let simulatedAnnealingAlg = SimulatedAnnealing()
  private let greedyPlacer = GreedyPlacer()
  
  func runOptimalPlacement(
    _ figures: [Figure],
    sheetWidth: Int,
    padding: Double
  ) async -> PlacementResult {
//    let gaTask = Task.detached(priority: .utility) {
//      self.geneticAlg.run(figures, sheetWidth: sheetWidth, padding: padding)
//    }
    
//    let saTask = Task.detached(priority: .utility) {
//      self.simulatedAnnealingAlg.run(figures, sheetWidth: sheetWidth, padding: padding)
//    }
    
    let greedyTask = Task.detached(priority: .utility) {
      self.greedyPlacer.place(figures, sheetWidth: sheetWidth, padding: padding)
    }
    
    let results = await [greedyTask.value/*, saTask.value, greedyTask.value*/]
    return results.min(by: { $0.totalHeight < $1.totalHeight })!
  }
}
