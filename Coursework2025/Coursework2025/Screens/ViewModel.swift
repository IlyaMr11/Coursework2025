//
//  HomeViewModel.swift
//  Coursework2025
//
//  Created by Илья Морозов on 24.03.2025.
//

import UIKit
import Combine

class ViewModel: ObservableObject {
  @Published var color: Bool = false
  @Published var resultView: UIView?
  @Published var resultData: PackingInput?
  @Published var alert: UIAlertController?
  @Published var data: PackingInput?
  @Published var scale: Double = 1
  var runOnSimmulator: Bool = Constants.runOnSimmulator
  
  let router: Router
  
  init(router: Router) {
    self.router = router
  }
  
  func decodeFile(url: URL?) {
    self.data = nil
    
    Task {
      do {
        if runOnSimmulator {
          let data = try DecodeLayer.decodeTestFile(name: Constants.fileName)
          self.data = data
        } else {
          let url = url!
          let data = try DecodeLayer.decode(url: url)
          self.data = data
        }
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
  
  func startProgramm()  {
    guard let data = self.data else {
      alert = AppAlerts.fileNotSelected
      return
    }
    
    router.showCanvasView()
    Task {
      await startCalculation(data: data)
    }
  }
  
  func startCalculation(data: PackingInput) async {
    let packingManager = PackingManager()
    let resultData = await packingManager.runOptimalPlacement(
      data.figures,
      sheetWidth: data.width,
      padding: 10
    )
    
    let (resultView, scale) = await DrawingLayer.shared.draw(
      data: resultData,
      canvasWidth: Double(data.width),
      color: color
    )

    await updateViewModel(data: data, view: resultView, scale: scale)
  }
  
  @MainActor
  func updateViewModel(data: PackingInput, view: UIView, scale: Double) async {
    self.resultData = data
    self.resultView = view
    self.scale = scale
  }
}
