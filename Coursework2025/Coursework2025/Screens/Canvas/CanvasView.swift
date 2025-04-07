//
//  CanvasViewController.swift
//  Coursework2025
//
//  Created by Илья Морозов on 24.03.2025.
//

import UIKit
import Combine

class CanvasView: UIViewController {
    
    var viewModel: ViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    private lazy var progressView: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView()
        progress.style = .large
        progress.color = .darkBlue
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        title = "Холст"
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLoading()
    }
    
    func bindViewModel() {
        guard let viewModel else { return }

        
        viewModel.$resultView
            .sink { [weak self] newView in
                guard let self else { return }
                
                if let newView {
                    self.canvasView.subviews.forEach { $0.removeFromSuperview() }
                    progressView.isHidden = true
                    self.canvasView.addSubview(newView)
                    newView.frame.origin = .zero
                }
            }
            .store(in: &cancellables)
            
    }
    
    func setupUI() {
        setupBackground()
        setupHintLabel()
        setupScaleLabel()
        setupCanvas()
    }
    
    func setupLoading() {
        canvasView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressView.widthAnchor.constraint(equalToConstant: 100),
            progressView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        progressView.startAnimating()
        
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
