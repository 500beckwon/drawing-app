//
//  DrawingInteractor.swift
//  Drawing
//
//  Created by ByungHoon Ann on 2023/11/13.
//

import Foundation

protocol DrawingBusinessLogic {
    func syncDrawingInfo()
    func makeRectangle(drawRect: DrawingRect)
    func startDrawLine(drawPoint: DrawPoint)
    func makeDrawingLine(drawPoint: DrawPoint)
    func endDrawingLine()
    func requestLogin(id: String)
    func serverFetch()
}

protocol DrawingActionLogic {
    func makeRectangle(drawRect: DrawingRect)
    func startDrawLine(drawPoint: DrawPoint)
    func makeDrawingLine(drawPoint: DrawPoint)
    func endDrawingLine()
}

protocol DrawingNetworkLogic {
    func requestLogin(id: String)
    func serverFetch()
}

protocol DrawingDataSource {
    var drawingResource: [DrawingInfo] { get set }
}

class DrawingInteractor: DrawingBusinessLogic, DrawingDataSource, ChatServerDelegate {
    var presenter: DrawingPresentationLogic?
    
    var drawUseCase: DrawingUseCase?
    var chatClientUseCase: ChatClientUseCase?
    var drawingResource: [DrawingInfo] = [DrawingInfo]()

    var server: ChatServerUseCase? {
        didSet {
            server?.delegate = self
        }
    }
    
    func syncDrawingInfo() {
        requestSendDrawingInfo()
        
    }
    
    func serverFetch() {
        server?.run()
        serverToConnect()
    }
    
    func requestLogin(id: String) {
        chatClientUseCase?.sendLoginRequest(id: id) { success in
            if success == false {
                self.presenter?.presentRequestFail(failMessage: .loginFailure)
            }
        }
    }
    
    func endDrawingLine() {
        guard let drawingPath = drawUseCase?.endDraw() else { return }
        drawingResource.append(drawingPath)
        presenter?.presentEndDrawingLine(drawingPath: drawingPath)
    }
    
    private func serverToConnect() {
        chatClientUseCase?.connectToServer() { success in
            if success == false {
                self.presenter?.presentRequestFail(failMessage: .serverConnectionFailure)
            }
        }
    }
    
    private func requestSendDrawingInfo() {
        chatClientUseCase?.sendChatRequest(drawingInfos: drawingResource) { success in
            if success == false {
                self.presenter?.presentRequestFail(failMessage: .chatFailure)
            }
        }
    }
    
    func makeRectangle(drawRect: DrawingRect) {
        guard let rectangle = drawUseCase?.makeRectangle(drawRect: drawRect) else { return }
        drawingResource.append(rectangle)
        presenter?.presentRectangle(info: rectangle)
    }
    
    func startDrawLine(drawPoint: DrawPoint) {
        drawUseCase?.startDraw(drawPoint: drawPoint)
    }
    
    func makeDrawingLine(drawPoint: DrawPoint) {
        guard let drawingPath = drawUseCase?.makingDraw(drawPoint: drawPoint) else { return }
        presenter?.presentDrawingLine(drawingPath: drawingPath)
    }
    
    func didReceiveResponse(_ response: CommandResponse) {
        switch response.header {
        case Response.Login:
            LoginStateManager.shared.loginUser(id: response.id)
            requestSendDrawingInfo()
        case Response.Chat:
            presenter?.presentChatResult()
        default:
            break
        }
    }
    
    func didConnectFail() {
        presenter?.presentRequestFail(failMessage: .chatFailure)
    }
}


