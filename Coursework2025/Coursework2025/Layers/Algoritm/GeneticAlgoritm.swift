//
//  GeneticAlgoritm.swift
//  Coursework2025
//
//  Created by Илья Морозов on 04.05.2025.
//

import Foundation

class GeneticAlgorithm {
  private let rotationManager = RotationManager(steps: Constants.rotationSteps)
  private let greedyPlacer = GreedyPlacer()
  
  func run(
    _ figures: [Figure],
    sheetWidth: Int,
    padding: Double,
    populationSize: Int = 4,
    generations: Int = 50
  ) -> PlacementResult {
    var population = generatePopulation(figures: figures, size: populationSize)
    for _ in 0..<generations {
      let evaluated = evaluate(population: population, sheetWidth: sheetWidth, padding: padding)
      let nextGeneration = evolve(evaluated, sheetWidth: sheetWidth, padding: padding)
      population = nextGeneration
    }
    let finalEvaluated = evaluate(population: population, sheetWidth: sheetWidth, padding: padding)
    return finalEvaluated.min(by: { $0.result.totalHeight < $1.result.totalHeight })?.result ?? PlacementResult.empty()
  }
  
  private func generatePopulation(figures: [Figure], size: Int) -> [[Figure]] {
    (0..<size).map { _ in figures.shuffled() }
  }
  
  private func evaluate(population: [[Figure]], sheetWidth: Int, padding: Double) -> [(individual: [Figure], result: PlacementResult)] {
    population.map { individual in
      let result = greedyPlacer.place(individual, sheetWidth: sheetWidth, padding: padding)
      return (individual, result)
    }
  }
  
  private func evolve(_ population: [(individual: [Figure], result: PlacementResult)], sheetWidth: Int, padding: Double) -> [[Figure]] {
    let sorted = population.sorted(by: { $0.result.totalHeight < $1.result.totalHeight })
    var newPopulation = [sorted[0].individual] // лучшая особь
    
    while newPopulation.count < population.count {
      let parent1 = selectParent(from: sorted)
      let parent2 = selectParent(from: sorted)
      let child = crossover(parent1, parent2)
      let mutatedChild = mutate(child)
      newPopulation.append(mutatedChild)
    }
    
    return newPopulation
  }
  
  private func selectParent(from population: [(individual: [Figure], result: PlacementResult)]) -> [Figure] {
    var totalFitness: Double = 0.0
    for item in population {
      totalFitness += 1.0 / (item.result.totalHeight + 1e-6)
    }
    
    var pick = Double.random(in: 0..<totalFitness)
    for individual in population {
      pick -= 1.0 / (Double(individual.result.totalHeight) + 1e-6)
      if pick <= 0 {
        return individual.individual
      }
    }
    return population[0].individual
  }
  
  private func crossover(_ a: [Figure], _ b: [Figure]) -> [Figure] {
    let splitIndex = Int.random(in: 0..<(min(a.count, b.count)))
    return Array(a[0..<splitIndex] + b[splitIndex...])
  }
  
  private func mutate(_ individual: [Figure]) -> [Figure] {
    var mutated = individual
    let index = Int.random(in: 0..<mutated.count)
    mutated[index] = rotationManager.getAllRotations(mutated[index]).randomElement()!
    return mutated
  }
}
