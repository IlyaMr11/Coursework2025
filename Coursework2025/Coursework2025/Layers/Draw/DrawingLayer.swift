//
//  DrawingLayer.swift
//  Coursework2025
//
//  Created by Илья Морозов on 25.03.2025.
//
import CoreGraphics
import UIKit


final class DrawingLayer {
  
  static let shared = DrawingLayer()
  
  private init() {}
  
  static let mockData = PlacementResult(placedFigures: [], totalHeight: 0.0)
  
  static let mockFigures: [Figure] = [
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 100, y: 0),
        Point(x: 100, y: 100),
        Point(x: 0, y: 100),
        Point(x: 0, y: 0)
      ], inCircuit: nil),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 100, y: 0),
        Point(x: 100, y: 300),
        Point(x: 0, y: 100),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 100, y: 100),
        Point(x: 200, y: 100),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 200, y: 100),
        Point(x: 50, y: 100),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 200, y: 100),
        Point(x: 50, y: 100),
        Point(x: 20, y: 70),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 100, y: 0),
        Point(x: 100, y: 300),
        Point(x: 0, y: 100),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 100, y: 100),
        Point(x: 200, y: 100),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 200, y: 100),
        Point(x: 50, y: 100),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 200, y: 100),
        Point(x: 50, y: 100),
        Point(x: 20, y: 70),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 100, y: 0),
        Point(x: 100, y: 100),
        Point(x: 0, y: 100),
        Point(x: 0, y: 0)
      ], inCircuit: nil),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 100, y: 0),
        Point(x: 100, y: 300),
        Point(x: 0, y: 100),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 100, y: 100),
        Point(x: 200, y: 100),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 200, y: 100),
        Point(x: 50, y: 100),
        Point(x: 0, y: 0),
      ],
      inCircuit: [
        Point(x: 20, y: 20),
        Point(x: 100, y: 70),
        Point(x: 90, y: 90),
        Point(x: 20, y: 20),
      ]
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 200, y: 100),
        Point(x: 50, y: 100),
        Point(x: 20, y: 70),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 100, y: 0),
        Point(x: 100, y: 300),
        Point(x: 0, y: 100),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 100, y: 100),
        Point(x: 200, y: 100),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 500, y: 100),
        Point(x: 50, y: 100),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
    
    Figure(
      outCircuit: [
        Point(x: 0, y: 0),
        Point(x: 200, y: 100),
        Point(x: 50, y: 100),
        Point(x: 20, y: 70),
        Point(x: 0, y: 0),
      ],
      inCircuit: nil
    ),
  ]
  
  @MainActor
  func draw(data: PlacementResult, canvasWidth: Double) -> (UIView, Double) {
    let screenWidth = UIScreen.main.bounds.width * 0.95
    let scale = screenWidth / canvasWidth
    let totalHeight = data.totalHeight * scale
    
    let scrollView = UIScrollView()
    scrollView.frame = UIScreen.main.bounds
    
    let contentView = UIView()
    contentView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
    
    let drawingView = DrawingView(
      data: data,
      canvasWidth: canvasWidth,
      scale: scale,
      totalHeight: totalHeight
    )
    drawingView.frame = contentView.bounds
    
    contentView.addSubview(drawingView)
    scrollView.addSubview(contentView)
    scrollView.contentSize = contentView.frame.size
    
    return (scrollView, scale)
  }
}


class DrawingView: UIView {
  var data: PlacementResult
  var canvasWidth: Double
  var scale: CGFloat
  var totalHeight: CGFloat
  var colors: [UIColor] = [.red, .blue, .green, .yellow, .orange]
  private let shiftLayer = ShiftLayer()
  
  init(data: PlacementResult, canvasWidth: Double, scale: CGFloat, totalHeight: CGFloat) {
    self.data = data
    self.canvasWidth = canvasWidth
    self.scale = scale
    self.totalHeight = totalHeight
    super.init(frame: .zero)
    backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else { return }
    var cnt = 0
    print("rect = \(rect)")
    
    for figure in data.placedFigures {
      let resultFigure = shiftLayer.place(figure).scaleFigure(scale: scale)
      let color = colors[cnt % colors.count]
      drawFigure(resultFigure, context: context, color: color)
      print(resultFigure)
      cnt += 1
    }
  }
  
  private func drawFigure(_ figure: Figure, context: CGContext, color: UIColor) {
    context.beginPath()
    
    // Рисуем внешний контур
    if !figure.outCircuit.isEmpty {
      context.beginPath()
      context.move(to: figure.outCircuit[0].cgPoint)
      for point in figure.outCircuit.dropFirst() {
        context.addLine(to: point.cgPoint)
      }
      context.closePath()
      
      color.setFill()
      context.fillPath()
      
      color.setStroke()
      context.strokePath()
    }
    
    // Рисуем внутренний контур (отверстие)
    if let inCircuit = figure.inCircuit, !inCircuit.isEmpty {
      context.beginPath()
      context.move(to: inCircuit[0].cgPoint)
      for point in inCircuit.dropFirst() {
        context.addLine(to: point.cgPoint)
      }
      context.closePath()
      
      UIColor.white.setFill()
      context.fillPath()
      
      color.setStroke() // Контур отверстия
      context.strokePath()
    }
    
  }
}
