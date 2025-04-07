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
            
        ], inCircuit: nil),
        
        Phigure(outCircuit: [
            Line.segment(Segment(start: Point(x: 120, y: 0), end: Point(x: 250, y: 150))),
            Line.segment(Segment(start: Point(x: 250, y: 150), end: Point(x: 250, y: 250))),
            Line.segment(Segment(start: Point(x: 250, y: 250), end: Point(x: 120, y: 0))),
            ], inCircuit: nil),
        
        Phigure(outCircuit: [
            Line.arc(Arc(start: Point(x: 100, y: 200), end: Point(x: 100, y: 200), radius: 100, center: Point(x: 100, y: 300), clockwise: true))
        ], inCircuit: nil),
        
        Phigure(outCircuit: [
            Line.segment(Segment(start: Point(x: 0, y: 400), end: Point(x: 20, y: 400))),
            Line.segment(Segment(start: Point(x: 20, y: 400), end: Point(x: 20, y: 430))),
            Line.arc(Arc(start: Point(x: 20, y: 430), end: Point(x: 20, y: 450), radius: 10, center: Point(x: 20, y: 440), clockwise: true)),
            Line.segment(Segment(start: Point(x: 20, y: 450), end: Point(x: 0, y: 400)))
        ]
        , inCircuit: nil)
    ]
    
    @MainActor
    func draw(data: DataModel) -> UIView {
        let resultView = DrawingView(data: DrawingLayer.mockData)
        
        return resultView
    }
    
    
}


class DrawingView: UIView {

    var data: DataModel
    var multiColor: Bool = false
    
    var colors: [UIColor] = [.blue, .green, .yellow, .red, .orange, .purple]
    
    override init(frame: CGRect) {
            self.data = DrawingLayer.mockData
            super.init(frame: frame)
            backgroundColor = .white
    }
    
    
    convenience init(data: DataModel, mulitColor: Bool = false) {
        let frame = CGRect(x: 0, y: 0, width: data.canvas.width, height: data.canvas.height)
        self.init(frame: frame)
        self.data = data
        self.multiColor = multiColor
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        var cnt = 0
        
        for phigure in data.phigures {
            let color = colors[cnt % colors.count]
            if (phigure.inCircuit != nil) {
                print("no impletment yet")
            } else {
                drawSimplePhigure(phigure.outCircuit, context: context, color: color)
            }
            
            cnt += 1
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawSimplePhigure(_ curve: [Line], context: CGContext, color: UIColor) {
        context.beginPath()
        
        switch curve[0] {
        case .arc(let arc):
            context.move(to: convertToCGPoint(arc.start))
        case .segment(let segment):
            context.move(to: convertToCGPoint(segment.start))
        }
    
        
        
        for line in curve {
            switch line {
            case .segment(let segment):
                drawSegment(segment, context: context)
            case .arc(let arc):
                drawArc(arc, context: context)
            }
        }
        
        context.closePath()
        
        color.setStroke()
        context.setLineWidth(1.0)
        color.setFill()
        
        context.drawPath(using: .fillStroke)
    }
    
    private func drawSegment(_ segment: Segment, context: CGContext) {
        
        //let start = convertToCGPoint(segment.start)
        let end = convertToCGPoint(segment.end)
        
        context.addLine(to: end)
    }
    
    private func drawArc(_ arc: Arc, context: CGContext) {
        let (startAngle, endAngle) = calculateAngles(arc: arc)
        let center = convertToCGPoint(arc.center)
        let radius: CGFloat = arc.radius
        
        if arc.start.x == arc.end.x && arc.start.y == arc.end.y {
            context.addArc(
                center: center,
                radius: radius,
                startAngle: 0,
                endAngle: .pi * 2,
                clockwise: !arc.clockwise
            )
        } else {
            context.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: !arc.clockwise
            )
        }
        
       
    }
    
    private func convertToCGPoint(_ point: Point) -> CGPoint {
        return CGPoint(x: point.x, y: point.y)
    }
    
    private func calculateAngles(arc: Arc) -> (startAngle: CGFloat, endAngle: CGFloat) {
        let center = convertToCGPoint(arc.center)
        let startPoint = convertToCGPoint(arc.start)
        let endPoint = convertToCGPoint(arc.end)
        
        let startAngle = atan2(startPoint.y - center.y, startPoint.x - center.x)
        var endAngle = atan2(endPoint.y - center.y, endPoint.x - center.x)
        
        // Корректировка направления
        if arc.clockwise {
            if endAngle < startAngle {
                endAngle += .pi * 2
            }
        } else {
            if endAngle > startAngle {
                endAngle -= .pi * 2
            }
        }
        
        return (startAngle, endAngle)
    }
}

