//
//  RectApproximator.swift
//  Coursework2025
//
//  Created by Илья Морозов on 02.05.2025.
//

import Foundation


class RectApproximator {
  private let lineWidth: Double
  var cache: [UUID: [Rectangle]] = [:]
  
  init(lineWidth: Double) {
    self.lineWidth = lineWidth
  }
  
  func approximate(figure: Figure) -> [Rectangle] {
    if let cachedResult = cache[figure.id] {
      return cachedResult
    }
    let allPoints = figure.outCircuit
    guard !allPoints.isEmpty else { return [] }
    
    let (minX, maxX, _, _) = ExtremumCalculator.figureExtremum(figure)
    let stripeCount = Int((maxX - minX) / lineWidth)
    var stripes = [Stripe](repeating: Stripe(), count: stripeCount + 1)
    
    for i in 0..<allPoints.count {
      let p = allPoints[i]
      let stripeIndex = Int((p.x - minX) / lineWidth)
      //Обновим текущую полосу
      stripes[stripeIndex].minY = min(stripes[stripeIndex].minY, p.y)
      stripes[stripeIndex].maxY = max(stripes[stripeIndex].maxY, p.y)
      
      if i > 0 { //Обработка отрезка между двумя точками (текущей и предыдущей)
        let prevP = allPoints[i-1]
        processSegment(from: prevP, to: p, minX: minX, lineWidth: lineWidth, stripes: &stripes)
      }
    }
    
    var rectangles = [Rectangle]()
    for (ind, stripe) in stripes.enumerated() {
      let xStart = minX + Double(ind) * lineWidth
      rectangles.append(
        Rectangle(
          minX: xStart,
          maxX: xStart + lineWidth,
          minY: stripe.minY,
          maxY: stripe.maxY
        )
      )
    }
    
    cache[figure.id] = rectangles
    return rectangles
  }
  
  private func processSegment(
    from p1: Point,
    to p2: Point, minX:
    Double, lineWidth: Double,
    stripes: inout [Stripe]
  ) {
    let x1 = p1.x
    let x2 = p2.x
    
    // Определяем направление отрезка
    let (left, right) = x1 < x2 ? (p1, p2) : (p2, p1)
    let dx = right.x - left.x
    let dy = right.y - left.y
    
    // Индексы начальной и конечной полосы
    let startStripe = Int((left.x - minX) / lineWidth)
    let endStripe = Int((right.x - minX) / lineWidth)
    
    // Обрабатываем все пересекаемые полосы
    for stripeIndex in startStripe...endStripe {
      let stripeX = minX + Double(stripeIndex) * lineWidth
      let nextStripeX = stripeX + lineWidth
      
      // Находим точку пересечения с границей полосы
      if stripeIndex > startStripe || stripeIndex < endStripe {
        let t = (stripeX - left.x) / dx
        let y = left.y + t * dy
        
        stripes[stripeIndex].minY = min(stripes[stripeIndex].minY, y)
        stripes[stripeIndex].maxY = max(stripes[stripeIndex].maxY, y)
      }
      
      // Для правой границы полосы
      if stripeIndex < endStripe {
        let t = (nextStripeX - left.x) / dx
        let y = left.y + t * dy
        
        stripes[stripeIndex].minY = min(stripes[stripeIndex].minY, y)
        stripes[stripeIndex].maxY = max(stripes[stripeIndex].maxY, y)
      }
    }
  }
  
  func clearCacheByID(_ id: UUID) {
    cache[id] = nil
  }
}
