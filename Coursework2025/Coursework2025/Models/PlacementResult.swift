//
//  PlacementResult.swift
//  Coursework2025
//
//  Created by Илья Морозов on 04.05.2025.
//

import Foundation

struct PlacementResult {
  let placedFigures: [PositionedFigure]
  let totalHeight: Double
  
  static func empty() -> Self {
    .init(placedFigures: [], totalHeight: .infinity)
  }
}
