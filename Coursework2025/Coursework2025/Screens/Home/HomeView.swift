//
//  ViewController.swift
//  Coursework2025
//
//  Created by Илья Морозов on 24.03.2025.
//

import UIKit
import Combine

class HomeView: UIViewController {
  
  var viewModel: ViewModel?
  
  var cancellables: Set<AnyCancellable> = []
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Добро пожаловать в\n Раскрой-Упаковку"
    label.font = .preferredFont(forTextStyle: .largeTitle)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.textColor = .white
    return label
  }()
  
  private lazy var chooseFileButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 15
    button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
    button.setTitle("Выбрать файл", for: .normal)
    button.titleLabel?.textAlignment = .center
    button.backgroundColor = .darkBlue
    button.titleLabel?.textColor = .white
    button.addTarget(self, action: #selector(chooseFile), for: .touchUpInside)
    button.addTarget(self, action: #selector(comeback(sender:)), for: .touchUpInside)
    button.addTarget(self, action: #selector(changeSize(sender:)), for: .touchDown)
    return button
  }()
  
  private lazy var colorSegmentedController: UISegmentedControl = {
    let segment = UISegmentedControl(items: ["Черно-Белая", "Разноцветная"])
    segment.layer.cornerRadius = 15
    segment.selectedSegmentIndex = 0
    segment.backgroundColor = .darkBlue
    segment.tintColor = .white
    segment.addTarget(self, action: #selector(changeColor), for: .valueChanged)
    
    let normalAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.white,
      .font: UIFont.preferredFont(forTextStyle: .headline)
    ]
    segment.setTitleTextAttributes(normalAttributes, for: .normal)
    
    
    let selectedAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.white,
      .font: UIFont.preferredFont(forTextStyle: .headline)
    ]
    segment.setTitleTextAttributes(selectedAttributes, for: .selected)
    
    segment.backgroundColor = UIColor.darkBlue
    
    segment.selectedSegmentTintColor = UIColor.systemCyan
    return segment
  }()
  
  private lazy var colorLabel: UILabel = {
    let label = UILabel()
    label.text = "Выберите цвет фигур"
    label.font = .preferredFont(forTextStyle: .title2)
    label.textAlignment = .center
    label.textColor = .white
    return label
  }()
  
  private lazy var startButton: UIButton = {
    let button = UIButton()
    button.setTitle("Старт", for: .normal)
    button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
    button.layer.cornerRadius = 15
    button.backgroundColor = .darkBlue
    button.addTarget(self, action: #selector(startProgramm), for: .touchUpInside)
    button.addTarget(self, action: #selector(comeback(sender:)), for: .touchUpInside)
    button.addTarget(self, action: #selector(changeSize(sender:)), for: .touchDown)
    return button
  }()
  
  private lazy var fileNameLabel: UILabel = {
    let label = UILabel()
    label.text = "Нет Файла"
    label.font = .preferredFont(forTextStyle: .headline)
    label.textAlignment = .right
    label.textColor = .black
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Главная"
    setupUI()
    bindViewModel()
  }
  
  func bindViewModel() {
    bindAlert()
    bindFileName()
  }
  
  
  func bindAlert() {
    
    viewModel?.$alert
      .sink { alert in
        RunLoop.main.perform {
          if let alert {
            self.present(alert, animated: true)
          }
        }
      }
      .store(in: &cancellables)
  }
  
  
  func bindFileName() {
    viewModel?.$data
      .sink {  data in
        RunLoop.main.perform {
          if data != nil {
            self.fileNameLabel.text = "Файл считан"
          } else {
            self.fileNameLabel.text = "Нет Файла"
          }
        }
      }
      .store(in: &cancellables)
  }
  
  func setupUI() {
    setupBackground()
    setupTitleLabel()
    setupColorLabel()
    setupSegment()
    setupFileButton()
    setupFileLabel()
    setupStartButton()
  }
  
  @objc private func chooseFile() {
    let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.json])
    documentPicker.delegate = self
    documentPicker.allowsMultipleSelection = false
    
    present(documentPicker, animated: true, completion: nil)
  }
  
  @objc private func startProgramm()  {
    viewModel?.startProgramm()
  }
  
  @objc private func changeColor() {
    viewModel?.color = colorSegmentedController.selectedSegmentIndex == 0 ? false : true
  }
  
  func setupTitleLabel() {
    view.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width),
      titleLabel.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.17),
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height * 0.05)
    ])
  }
  
  func setupColorLabel() {
    view.addSubview(colorLabel)
    colorLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      colorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      colorLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.7),
      colorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: view.bounds.height * 0.1),
      colorLabel.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05)])
  }
  
  func setupSegment() {
    view.addSubview(colorSegmentedController)
    colorSegmentedController.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      colorSegmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      colorSegmentedController.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.75),
      colorSegmentedController.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: view.bounds.height * 0.025),
      colorSegmentedController.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.075)])
  }
  
  func setupFileButton() {
    view.addSubview(chooseFileButton)
    chooseFileButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      chooseFileButton.leadingAnchor.constraint(equalTo: colorSegmentedController.leadingAnchor),
      chooseFileButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.4),
      chooseFileButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.075),
      chooseFileButton.topAnchor.constraint(equalTo: colorSegmentedController.bottomAnchor, constant: view.bounds.height * 0.1)
    ])
  }
  
  func setupFileLabel() {
    view.addSubview(fileNameLabel)
    fileNameLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      fileNameLabel.leadingAnchor.constraint(equalTo: chooseFileButton.trailingAnchor, constant: +view.bounds.width * 0.05),
      fileNameLabel.heightAnchor.constraint(equalTo: chooseFileButton.heightAnchor),
      fileNameLabel.topAnchor.constraint(equalTo: chooseFileButton.topAnchor),
      fileNameLabel.trailingAnchor.constraint(equalTo: colorSegmentedController.trailingAnchor)
      
    ])
  }
  
  func setupStartButton() {
    view.addSubview(startButton)
    startButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      startButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.075),
      startButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.7),
      startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.bounds.height * 0.05)
    ])
  }
  
}

extension HomeView: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let selectedFileURL = urls.first else { return }
    
    viewModel?.decodeFile(url: selectedFileURL)
  }
  
  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    print("Document picker was cancelled")
  }
}
