//
//  AlertContext.swift
//  Coursework2025
//
//  Created by Илья Морозов on 06.04.2025.
//

import Foundation

struct AppAlerts {
    
    static let invalidFile = Alert(title: "Ошибка чтнеия",
                                   message: "Данные в файле не удалось обработать, попробуйте еще раз или выберите другой файл",
                                   completion: nil)
    
    static let serverAlert = Alert(title: "Ошибка сервера",
                                   message: "Произошла ошибка, попробуйте еще раз",
                                   completion: nil)
}

struct Alert {
    let title: String
    let message: String
    let completion: (() -> Void)?
}
