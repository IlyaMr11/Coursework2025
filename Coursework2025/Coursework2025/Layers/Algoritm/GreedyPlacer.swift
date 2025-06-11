//
//  GreedyPlacer.swift
//  Coursework2025
//
//  Created by Илья Морозов on 04.05.2025.
//

import Foundation

class GreedyPlacer {
  private let shiftLayer = ShiftLayer()
  private let rotationManager = RotationManager(steps: Constants.rotationSteps)
  private let approximator = RectApproximator(lineWidth: 20)
  private let collisionChecker = CollisionChecker()
  
  func place(
    _ figures: [Figure],
    sheetWidth: Int,
    padding: Double
  ) -> PlacementResult {
    var result: [PositionedFigure] = []
    let sortedFigures = sortFiguresByArea(figures)
    
    for originalFigure in sortedFigures {
      let rotations = rotationManager.getAllRotations(originalFigure)
      
      for rotatedFigure in rotations {
        approximator.clearCacheByID(rotatedFigure.id)
        
        if let position = findBottomLeftPosition(rotatedFigure,
          placedFigures: result,
          sheetWidth: sheetWidth,
          padding: padding
        ) {
          result.append(PositionedFigure(figure: rotatedFigure, origin: position))
          break
        }
      }
    }
    
    let totalHeight = calculateTotalHeight(result)
    return PlacementResult(placedFigures: result, totalHeight: totalHeight)
  }
  
  private func sortFiguresByArea(_ figures: [Figure]) -> [Figure] {
    for fig in figures {
      print(areaOfFigure(fig))
    }
    return figures.sorted(by: { areaOfFigure($0) > areaOfFigure($1) })
  }
  
  private func areaOfFigure(_ figure: Figure) -> Double {
    let rects = approximator.approximate(figure: figure)
    let square = rects.reduce(0) { $0 + abs($1.maxX - $1.minX) * abs($1.maxY - $1.minY) }
    return square
  }
  
  func findBottomLeftPosition(
    _ figure: Figure,
    placedFigures: [PositionedFigure],
    sheetWidth: Int,
    padding: Double
  ) -> Point? {
    let stepX = Constants.stepX
    let stepY = Constants.stepY
    let maxHeight = Constants.maxHeight
    let sheetWidthDouble = Double(sheetWidth)
    
    var lowY = 0.0
    var highY = Double(maxHeight)
    var bestPosition: Point? = nil
    while lowY <= highY {
      let midY = (lowY + highY) / 2
      let roundedY = (midY / stepY).rounded(.down) * stepY // Привязка к сетке stepY
      
      // Линейный поиск по X для текущего Y
      var found = false
      for x in stride(from: 0.0, to: sheetWidthDouble, by: stepX) {
        let position = Point(x: x, y: roundedY)
        
        if !collisionChecker.checkCollision(
          figure: figure,
          at: position,
          placedFigures: placedFigures,
          padding: padding,
          approximator: approximator,
          shiftLayer: shiftLayer,
          width: sheetWidth
        ) {
          bestPosition = position
          found = true
          break
        }
      }
      
      if found {
        highY = midY - stepY // Пробуем найти меньший Y
      } else {
        lowY = midY + stepY // Идем выше
      }
    }
    
    return bestPosition
  }
  
  func calculateTotalHeight(_ placedFigures: [PositionedFigure]) -> Double {
    var mx = -1.0
    for pF in placedFigures {
      mx = max(ExtremumCalculator.figureExtremum(shiftLayer.place(pF)).maxY, mx)
    }
    return mx + 10
  }
}
