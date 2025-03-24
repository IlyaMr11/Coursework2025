//
//  HomeViewModel.swift
//  Coursework2025
//
//  Created by Илья Морозов on 24.03.2025.
//

import UIKit
import Combine


class HomeViewModel {
    @Published var color: Int = 0
    @Published var data: [Phigure]?
    
    func decodeFile() {
        MockDecoder.mockDecode()
    }
}
