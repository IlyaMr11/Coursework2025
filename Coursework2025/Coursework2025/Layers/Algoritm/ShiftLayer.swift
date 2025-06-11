//
//  ShfitLayer.swift
//  Coursework2025
//
//  Created by Илья Морозов on 10.05.2025.
//

import Foundation

class ShiftLayer {
  func shiftFigure(_ figure: Figure) -> Figure {
    let (minXPoint, _, minYPoint, _) = ExtremumCalculator.figureExtremum(figure)
    
    let minX = min(minXPoint, 0)
    let minY = min(minYPoint, 0)
    
    return shiftOnDelta(figure, delta: Point(x: -minX, y: -minY))
  }
  
  func shiftOnDelta(_ figure: Figure, delta: Point) -> Figure {
    let shiftedOutCircuit = figure.outCircuit.map { point in
      Point(x: point.x + delta.x, y: point.y + delta.y)
    }
    
    let shiftedInCircuit = figure.inCircuit?.map { point in
      Point(x: point.x + delta.x, y: point.y + delta.y)
    }
    
    return Figure(
      id: figure.id,
      outCircuit: shiftedOutCircuit,
      inCircuit: shiftedInCircuit
    )
  }
  
  func place(_ positionedFigure: PositionedFigure) -> Figure {
    let delta = positionedFigure.origin
    let figure = positionedFigure.figure
    
    return shiftOnDelta(figure, delta: delta)
  }
  
  func shiftApproxime(_ rects: [Rectangle], delta: Point) -> [Rectangle] {
    rects.map { rect in
      Rectangle(
        minX: rect.minX + delta.x,
        maxX: rect.maxX + delta.x,
        minY: rect.minY + delta.y,
        maxY: rect.maxY + delta.y
      )
    }
  }
}
