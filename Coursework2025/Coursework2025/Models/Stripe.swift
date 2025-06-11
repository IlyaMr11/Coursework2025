//
//  Stripe.swift
//  Coursework2025
//
//  Created by Илья Морозов on 03.05.2025.
//

import Foundation

struct Stripe {
    var minY: Double
    var maxY: Double
    init() {
        minY = .greatestFiniteMagnitude
        maxY = -.greatestFiniteMagnitude
    }
}
