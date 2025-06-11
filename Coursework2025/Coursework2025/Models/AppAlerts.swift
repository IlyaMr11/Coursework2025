//
//  AlertContext.swift
//  Coursework2025
//
//  Created by Илья Морозов on 06.04.2025.
//

import UIKit

struct AppAlerts {
  
  static let invalidFile: UIAlertController = {
    let alert = UIAlertController(
      title: "Ошибка чтнеия",
      message: "Данные в файле не удалось обработать, попробуйте еще раз или выберите другой файл",
      preferredStyle: .alert)
    let action = UIAlertAction(title: "Ок", style: .default)
    alert.addAction(action)
    return alert
  }()
  
  static let serverAlert: UIAlertController = {
    let alert = UIAlertController(
      title: "Ошибка сервера",
      message: "Произошла ошибка, попробуйте еще раз",
      preferredStyle: .alert)
    let action = UIAlertAction(title: "Ок", style: .default)
    alert.addAction(action)
    return alert
  }()
  
  static let fileNotSelected: UIAlertController = {
    let alert = UIAlertController(
      title: "Файл не выбран",
      message: "Выберете корректный файл и повторите попытку",
      preferredStyle: .alert)
    let action = UIAlertAction(title: "Ок", style: .default)
    alert.addAction(action)
    return alert
  }()
}

struct Alert {
  let title: String
  let message: String
  let completion: (() -> Void)?
}
