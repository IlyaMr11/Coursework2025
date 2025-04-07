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
    
    static let mockData = DataModel(canvas: mockCanvas, phigures: mockPhigures)
    
    static let mockCanvas = Canvas(width: 300, height: 600)
    
    static let mockPhigures: [Phigure] = [
        Phigure(outCircuit: [
            Line.segment(Segment(start: Point(x: 0, y: 0), end: Point(x: 100, y: 0))),
            Line.segment(Segment(start: Point(x: 100, y: 0), end: Point(x: 100, y: 100))),
            Line.segment(Segment(start: Point(x: 100, y: 100), end: Point(x: 0, y: 100))),
            Line.segment(Segment(start: Point(x: 0, y: 100), end: Point(x: 0, y: 0)))
            
        ], inCircuit: nil)
    ]
    
    @MainActor
    func draw(data: DataModel) -> UIView {
        let resultView = DrawingView(data: DrawingLayer.mockData)
        
        return resultView
    }
    
    
}


class DrawingView: UIView {

    var data: DataModel
    
    override init(frame: CGRect) {
            self.data = DrawingLayer.mockData
            super.init(frame: frame)
            backgroundColor = .white
    }
    
    
    convenience init(data: DataModel) {
        let frame = CGRect(x: 0, y: 0, width: data.canvas.width, height: data.canvas.height)
        self.init(frame: frame)
        self.data = data
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for phigure in data.phigures {
            if (phigure.inCircuit != nil) {
                print("no impletment yet")
            } else {
                drawSimplePhigure(phigure.outCircuit, context: context, color: .blue)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawSimplePhigure(_ curve: [Line], context: CGContext, color: UIColor) {
        context.beginPath()
        
        if case let .segment(firstSegment) = curve.first {
            context.move(to: convertToCGPoint(firstSegment.start))
        }
        
        for line in curve {
            switch line {
            case .segment(let segment):
                drawSegment(segment, context: context)
            case .arc(let arc):
                print("arc not implemented yet")
            }
        }
        
        context.closePath()
        
        color.setStroke()
        context.setLineWidth(1.0)
        color.setFill()
        
        context.drawPath(using: .fillStroke)
    }
    
    private func drawSegment(_ segment: Segment, context: CGContext) {
        
        let start = convertToCGPoint(segment.start)
        let end = convertToCGPoint(segment.end)
        
        context.addLine(to: end)
    }
    
    private func convertToCGPoint(_ point: Point) -> CGPoint {
        return CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))
    }
}

