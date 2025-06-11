//
//  Router.swift
//  Coursework2025
//
//  Created by Илья Морозов on 06.04.2025.
//

import UIKit

class Router {
  var navigationController: UINavigationController?
  weak var viewModel: ViewModel?
  
  func showHomeView() {
    let homeView = HomeView()
    homeView.viewModel = self.viewModel
    self.navigationController = UINavigationController(rootViewController: homeView)
  }
  
  func showCanvasView() {
    let canvasView = CanvasView()
    canvasView.viewModel = self.viewModel
    self.navigationController?.pushViewController(canvasView, animated: true)
  }
}
