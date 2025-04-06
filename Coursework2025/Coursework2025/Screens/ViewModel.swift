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
    @Published var resultView: UIView?
    @Published var resultData: DataModel?
    @Published var alert: Alert?
    
    
    func decodeFile(url: URL) {
     
        Task {
            do {
                let data = try DecodeLayer.decode(url: url)
                await self.startCalculation(data: data)
            } catch {
                if let error = error as? AppErrors {
                    switch error {
                    case .invalidFile:
                        self.alert = AppAlerts.invalidFile
                    case .serverError:
                        self.alert = AppAlerts.serverAlert
                    }
                } else {
                    self.alert = AppAlerts.serverAlert
                }
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
        self.resultData = data
        self.resultView = view
    }
    
}
