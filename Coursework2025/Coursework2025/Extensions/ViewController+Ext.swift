//
//  ViewController+Ext.swift
//  Coursework2025
//
//  Created by Илья Морозов on 25.03.2025.
//

import UIKit

extension UIViewController {
    func setupBackground() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.systemBlue.cgColor,
                                UIColor.white.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc func changeSize(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 0.7
            sender.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        }
    }
    
    @objc func comeback(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 1
            sender.transform = CGAffineTransform.identity
        }
    }
}
