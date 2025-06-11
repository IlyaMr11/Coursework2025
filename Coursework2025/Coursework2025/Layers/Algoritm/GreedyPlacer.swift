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

class FastGreedyPlacer {
  private let sheetWidth: Int
  private let padding: Double
  private var occupiedPositions: [Point] = []
  private let shiftLayer = ShiftLayer()
  
  init(sheetWidth: Int, padding: Double) {
    self.sheetWidth = sheetWidth
    self.padding = padding
  }
  
  func place(_ figures: [Figure]) -> PlacementResult {
    var placedFigures: [PositionedFigure] = []
    occupiedPositions.removeAll()
    
    for figure in figures {
      if let position = findBestPosition(for: figure) {
        placedFigures.append(PositionedFigure(figure: figure, origin: position))
        markOccupied(position: position, figure: figure)
      }
    }
    
    let totalHeight = calculateTotalHeight(placedFigures)
    return PlacementResult(placedFigures: placedFigures, totalHeight: totalHeight)
  }
  
  func findBestPosition(for figure: Figure) -> Point? {
    // Пробуем углы уже размещённых фигур
    for corner in occupiedPositions {
      if isValid(position: corner, for: figure) {
        return corner
      }
    }
    
    // Линейный поиск с шагом
    let step = 5.0
    var y: Double = 0
    
    while y < (occupiedPositions.map { $0.y }.max() ?? 0) + 100 {
      var x: Double = 0
      
      while x < Double(sheetWidth) {
        let position = Point(x: x, y: y)
        if isValid(position: position, for: figure) {
          return position
        }
        x += step
      }
      
      y += step
    }
    
    return nil
  }
  
  private func isValid(position: Point, for figure: Figure) -> Bool {
    // Упрощённая проверка коллизий
    let figureBounds = CGRect(
      x: position.x,
      y: position.y,
      width: figure.width + padding,
      height: figure.height + padding
    )
    
    for placed in occupiedPositions {
      let placedBounds = CGRect(
        x: placed.x - padding,
        y: placed.y - padding,
        width: figure.width + 2 * padding,
        height: figure.height + 2 * padding
      )
      
      if figureBounds.intersects(placedBounds) {
        return false
      }
    }
    
    return position.x + figure.width <= Double(sheetWidth)
  }
  
  private func markOccupied(position: Point, figure: Figure) {
    // Добавляем углы фигуры
    occupiedPositions.append(position)
    occupiedPositions.append(Point(x: position.x + figure.width, y: position.y))
    occupiedPositions.append(Point(x: position.x, y: position.y + figure.height))
    occupiedPositions.append(Point(x: position.x + figure.width, y: position.y + figure.height))
  }
  
  func calculateTotalHeight(_ placedFigures: [PositionedFigure]) -> Double {
    var mx = -1.0
    for pF in placedFigures {
      mx = max(ExtremumCalculator.figureExtremum(shiftLayer.place(pF)).maxY, mx)
    }
    return mx + 10
  }
}


class HybridGreedyPlacer {
  private let sheetWidth: Int
  private let padding: Double
  private let shiftLayer = ShiftLayer()
  private let collisionChecker = CollisionChecker()
  private let approximator = RectApproximator(lineWidth: 0.5)
  
  init(sheetWidth: Int, padding: Double) {
    self.sheetWidth = sheetWidth
    self.padding = padding
  }
  
  func place(_ figures: [Figure]) -> PlacementResult {
    var placedFigures: [PositionedFigure] = []
    
    for figure in figures {
      if let position = findPosition(for: figure, placedFigures: placedFigures) {
        placedFigures.append(PositionedFigure(figure: figure, origin: position))
      }
    }
    
    let totalHeight = calculateTotalHeight(placedFigures)
    return PlacementResult(placedFigures: placedFigures, totalHeight: totalHeight)
  }
  
  private func findPosition(for figure: Figure, placedFigures: [PositionedFigure]) -> Point? {
    // Быстрая проверка через bounding box
    let simplePlacer = FastGreedyPlacer(sheetWidth: sheetWidth, padding: padding)
    if let position = simplePlacer.findBestPosition(for: figure) {
      // Точная проверка коллизий
      if !collisionChecker.checkCollision(
        figure: figure,
        at: position,
        placedFigures: placedFigures,
        padding: padding, approximator: approximator,
        shiftLayer: shiftLayer,
        width: sheetWidth
      ) {
        return position
      }
    }
    return nil
  }
  
  func calculateTotalHeight(_ placedFigures: [PositionedFigure]) -> Double {
    var mx = -1.0
    for pF in placedFigures {
      mx = max(ExtremumCalculator.figureExtremum(shiftLayer.place(pF)).maxY, mx)
    }
    return mx + 10
  }
}


extension Figure {
  var width: Double {
    let xs = outCircuit.map { $0.x }
    guard let minX = xs.min(), let maxX = xs.max() else { return 0 }
    return maxX - minX
  }
  
  var height: Double {
    let ys = outCircuit.map { $0.y }
    guard let minY = ys.min(), let maxY = ys.max() else { return 0 }
    return maxY - minY
  }
}
