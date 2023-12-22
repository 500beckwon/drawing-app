//
//  CanvasView.swift
//  Drawing
//
//  Created by ByungHoon Ann on 2023/11/12.
//

import UIKit

final class CanvasView: UIView {
    var interactor: DrawingBusinessLogic?
    
    var isDrawingMode = false
    var shapeLayers = [CAShapeLayer]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawingMode else { return }
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        interactor?.startDrawLine(drawPoint: location.drawPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawingMode else { return }
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        interactor?.makeDrawingLine(drawPoint: location.drawPoint)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawingMode else { return }
        
        interactor?.endDrawingLine()
    }
    
    func syncDrawing(infos: [DrawingInformation]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            infos.forEach {
                if $0.drawingType == .rectangle {
                    self.appendRectangle(info: $0)
                }
                
                if $0.drawingType == .line {
                    self.makeDrawingLineView(info: $0)
                }
            }
        }
    }
    
    func makeDrawingLineView(info: DrawingInformation) {
        guard let pathInfo = info.pathInfo else { return }
        shapeLayers.forEach{ $0.removeFromSuperlayer() }
        shapeLayers.removeAll()
        
        let path = makeBezierPath(pathInfo: pathInfo)
        let shapeLayer = makeShapeLayer()
        let drawButton = DrawedButton(info: info)
        
        drawButton.drawingPathView(bezierPath: path, shapeLayer: shapeLayer)
        drawButton.addTarget(self, action: #selector(handleShapeTap), for: .touchUpInside)
        addSubview(drawButton)
    }
    
    func drawDrawing(drawingPath: DrawingInformation) {
        guard let pathInfo = drawingPath.pathInfo else { return }
        let path = makeBezierPath(pathInfo: pathInfo)
        let shapeLayer = makeShapeLayer()
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
        shapeLayers.append(shapeLayer)
    }
    
    func appendRectangle(info: DrawingInformation) {
        let button = DrawedButton(info: info)
        button.addTarget(self, action: #selector(handleShapeTap), for: .touchUpInside)
        addSubview(button)
    }
    
    func makeShapeLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5.0
        return shapeLayer
    }
    
    func makeBezierPath(pathInfo: DrawingPathInfo) -> UIBezierPath {
        let path = UIBezierPath()
        path.accessibilityLabel = pathInfo.id
        path.move(to: pathInfo.startPoint)
        pathInfo.pathPoint.forEach { path.addLine(to: $0) }
        return path
    }
}

extension CanvasView {
    func deselectSelectedShape(id: String? = nil) {
        _ = getRectangleViews()
            .filter { $0.info.id != id }
            .map { $0.clear() }
    }
    
    func getRectangleViews() -> [DrawedButton] {
        return subviews
            .compactMap { $0 as? DrawedButton }
    }
}

private extension CanvasView {
    @objc func handleShapeTap(_ sender: DrawedButton) {
        sender.active()
        deselectSelectedShape(id: sender.info.id)
    }
    
    func basicSetUI() {
        backgroundColor = .white
    }
}
