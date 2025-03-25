//
//  CalclulationLayer.swift
//  Coursework2025
//
//  Created by Илья Морозов on 25.03.2025.
//

import Foundation


final class CalculationLayer {
    
    static let shared = CalculationLayer()
    
    private init() {}
    
    func calculate(data: DataModel) -> DataModel {
        return data
    }
}
