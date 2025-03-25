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
    
    @MainActor
    func draw(data: DataModel) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        view.backgroundColor = .yellow
        
        return view
    }
}


