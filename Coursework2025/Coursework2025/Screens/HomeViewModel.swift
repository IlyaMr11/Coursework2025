//
//  HomeViewModel.swift
//  Coursework2025
//
//  Created by Илья Морозов on 24.03.2025.
//

import UIKit
import Combine


class HomeViewModel: ObservableObject {
    @Published var color: Int = 0
    @Published var data: DataModel?
    @Published var resultView: UIView?
    
    
    func decodeFile() {
        MockDecoder.mockDecode()
    }
    
    func startCalculation(data: DataModel) {
        self.data = CalculationLayer.shared.calculate(data: data)
        self.resultView = DrawingLayer.shared.draw(data: data)
    }
    
    
}
