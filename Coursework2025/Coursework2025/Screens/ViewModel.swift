//
//  HomeViewModel.swift
//  Coursework2025
//
//  Created by Илья Морозов on 24.03.2025.
//

import UIKit
import Combine


class ViewModel: ObservableObject {
    @Published var color: Int = 0
    @Published var data: DataModel?
    @Published var resultView: UIView?
    
    
    func decodeFile() {
        Task {
            do {
                let decodeData = try await MockDecoder.mockDecode()
                
                await startCalculation(data: decodeData)
            } catch {
                print("error")
            }
        }
        
    }
    
    func startCalculation(data: DataModel) async {
        let resultData = CalculationLayer.shared.calculate(data: data)
        
        let resultView = await DrawingLayer.shared.draw(data: resultData)
        await updateViewModel(data: data, view: resultView)
    }
    
    @MainActor
    func updateViewModel(data: DataModel, view: UIView) async {
        self.data = data
        self.resultView = view
    }
    
}
