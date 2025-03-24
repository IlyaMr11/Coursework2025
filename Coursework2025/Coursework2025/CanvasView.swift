//
//  CanvasViewController.swift
//  Coursework2025
//
//  Created by Илья Морозов on 24.03.2025.
//

import UIKit

class CanvasView: UIViewController {
    
    var scale = 1
    
    private lazy var canvasView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.text = "Масштаб:"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var scaleLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        title = "Холст"
        setupUI()
    }
    
    func setupUI() {
        setupBackground()
        setupHintLabel()
        setupScaleLabel()
        setupCanvas()
    }
    
    func setupHintLabel() {
        view.addSubview(hintLabel)
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            hintLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            hintLabel.widthAnchor.constraint(equalToConstant: 150),
            hintLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupScaleLabel() {
        view.addSubview(scaleLabel)
        scaleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scaleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            scaleLabel.topAnchor.constraint(equalTo: hintLabel.topAnchor),
            scaleLabel.widthAnchor.constraint(equalToConstant: 150),
            scaleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupCanvas() {
        view.addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            canvasView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 10),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            canvasView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

}
