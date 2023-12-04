//
//  ViewController.swift
//  Drawing
//
//  Created by ByungHoon Ann on 2023/11/05.
//

import UIKit
import Network

protocol DrawingDisplayLogic: AnyObject {
    func displayDrawing(info: DrawingInformation)
    func displayDrawingLine(info: DrawingInformation)
    func displayEndDrawingLine(info: DrawingInformation)
    func displayRequestFail(failMessage: AlertMessage)
    func displayLoginResult(success: Bool)
    func displayChatResult(drawingInfo: [DrawingInformation])
}

final class ViewController: UIViewController, DrawingDisplayLogic {
    
    var interactor: DrawingBusinessLogic?
    
    private let canvasView = CanvasView()
    private let makeRectangleButton = UIButton()
    private let makeDrawLineButton = UIButton()
    private let syncButton = UIButton()
    private let stackView = UIStackView()
    private let loginView = LoginView()
    private let editItemView = EditItemView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
        serverFetch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    func displayDrawing(info: DrawingInformation) {
        canvasView.appendRectangle(info: info)
    }
    
    func displayDrawingLine(info: DrawingInformation) {
        canvasView.drawDrawing(drawingPath: info)
    }
    
    func displayEndDrawingLine(info: DrawingInformation) {
        canvasView.makeDrawingLineView(info: info)
    }
    
    func displayRequestFail(failMessage: AlertMessage) {
        loginView.clear()
        showAlert(type: failMessage)
    }
    
    func displayLoginResult(success: Bool) {
        interactor?.syncDrawingInfo()
    }
    
    func displayChatResult(drawingInfo: [DrawingInformation]) {
        guard drawingInfo.isEmpty == false else { return }
        showAlert(type: .loginSuccess) { [weak self] in
            guard let self = self else { return }
            self.canvasView.syncDrawing(infos: drawingInfo)
        }
    }
    
    func displayLoginResult() {
        loginView.clear()
        showAlert(type: .loginSuccess)
    }
    
    func displayChatResult() {
        showAlert(type: .chatSuccess)
    }
    
    private func serverFetch() {
        interactor?.serverFetch()
    }
    
    private func setup() {
        let viewController = self
        let canvasView = viewController.canvasView
        let loginView = viewController.loginView
        let interactor = DrawingInteractor()
        let presenter = DrawingPresenter()
        let drawUseCase = DrawingUseCaseImpl()
        let server = ChatServer(with: .init(integerLiteral: 9090))
        let chatClientUseCase = ChatClientImpl()
        
        viewController.interactor = interactor
        canvasView.interactor = interactor
        loginView.interactor = interactor
        interactor.presenter = presenter
        interactor.drawUseCase = drawUseCase
        interactor.chatClientUseCase = chatClientUseCase
        interactor.server = server
        presenter.viewController = viewController
    }
}

/// Event Action

private extension ViewController {
    @objc func makeRectangleButtonTapped(_ sender: UIButton) {
        makeDrawLineButton.isSelected = false
        canvasView.isDrawingMode = false
        interactor?.makeRectangle(drawRect: canvasView.frame.convertDrawingRect())
    }
    
    @objc func makeDrawLineButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        canvasView.isDrawingMode = sender.isSelected
    }
    
    @objc func syncButtonTapped(_ sender: UIButton) {
        if LoginStateManager.shared.isUserLogin() == true {
            interactor?.syncDrawingInfo()
        }
        
        if LoginStateManager.shared.isUserLogin() == false {
            loginView.isHidden = false
        }
    }
    
    func showAlert(type: AlertMessage, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel) { _ in
            completion?()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(alert, animated: true)
        }
    }
}

/// UI Layout

private extension ViewController {
    func layout() {
        insertUI()
        basicSetUI()
        anchorUI()
    }
    
    func insertUI() {
        [
            canvasView,
            stackView,
            editItemView,
            loginView
        ].forEach {
            view.addSubview($0)
        }
        stackView.addArrangedSubview(makeRectangleButton)
        stackView.addArrangedSubview(makeDrawLineButton)
        stackView.addArrangedSubview(syncButton)
    }
    
    func basicSetUI() {
        canvasViewBasicSet()
        loginViewBasicSet()
        makeRectangleButtonBasicSet()
        makeDrawLineButtonBasicSet()
        syncButtonBasicSet()
        editItemViewBasicSet()
        stackViewBasicSet()
    }
    
    func anchorUI() {
        canvasViewAnchor()
        stackViewAnchor()
        makeRectangleButtonAnchor()
        makeDrawLineButtonAnchor()
        syncButtonAnchor()
        editItemViewAnchor()
        loginViewAnchor()
    }
    
    func stackViewBasicSet() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func canvasViewBasicSet() {
        canvasView.backgroundColor = .white
        canvasView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func loginViewBasicSet() {
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.isHidden = true
    }
    
    func editItemViewBasicSet() {
        editItemView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func makeRectangleButtonBasicSet() {
        makeRectangleButton.setTitle("사각형", for: .normal)
        makeRectangleButton.setTitleColor(.darkGray, for: .normal)
        makeRectangleButton.backgroundColor = .white
        makeRectangleButton.addTarget(self, action: #selector(makeRectangleButtonTapped), for: .touchUpInside)
        makeRectangleButton.layer.borderWidth = 1
        makeRectangleButton.layer.borderColor = UIColor.black.cgColor
        makeRectangleButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func makeDrawLineButtonBasicSet() {
        makeDrawLineButton.setTitle("그리기", for: .normal)
        makeDrawLineButton.setTitle("그리기", for: .selected)
        makeDrawLineButton.setTitleColor(.darkGray, for: .normal)
        makeDrawLineButton.setTitleColor(.black, for: .selected)
        makeDrawLineButton.backgroundColor = .white
        makeDrawLineButton.addTarget(self, action: #selector(makeDrawLineButtonTapped), for: .touchUpInside)
        makeDrawLineButton.layer.borderWidth = 1
        makeDrawLineButton.layer.borderColor = UIColor.black.cgColor
        makeDrawLineButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func syncButtonBasicSet() {
        syncButton.setTitle("동기화", for: .normal)
        syncButton.setTitleColor(.darkGray, for: .normal)
        syncButton.backgroundColor = .white
        syncButton.addTarget(self, action: #selector(syncButtonTapped), for: .touchUpInside)
        syncButton.layer.borderWidth = 1
        syncButton.layer.borderColor = UIColor.black.cgColor
        syncButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func canvasViewAnchor() {
        NSLayoutConstraint.activate(
            [
                canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                canvasView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                canvasView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
    }
    
    func stackViewAnchor() {
        NSLayoutConstraint.activate(
            [
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                stackView.heightAnchor.constraint(equalToConstant: 100)
            ]
        )
    }
    
    func makeRectangleButtonAnchor() {
        NSLayoutConstraint.activate(
            [
                makeRectangleButton.widthAnchor.constraint(equalToConstant: 100),
                makeRectangleButton.heightAnchor.constraint(equalToConstant: 100)
            ]
        )
    }
    
    func makeDrawLineButtonAnchor() {
        NSLayoutConstraint.activate(
            [
                makeDrawLineButton.widthAnchor.constraint(equalToConstant: 100),
                makeDrawLineButton.heightAnchor.constraint(equalToConstant: 100)
            ]
        )
    }
    
    func syncButtonAnchor() {
        NSLayoutConstraint.activate(
            [
                syncButton.widthAnchor.constraint(equalToConstant: 100),
                syncButton.heightAnchor.constraint(equalToConstant: 100)
            ]
        )
    }
    
    func editItemViewAnchor() {
        NSLayoutConstraint.activate(
            [
                editItemView.widthAnchor.constraint(equalToConstant: 50),
                editItemView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                editItemView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            ]
        )
    }
    
    func loginViewAnchor() {
        NSLayoutConstraint.activate(
            [
                loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                loginView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                loginView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
    }
}
