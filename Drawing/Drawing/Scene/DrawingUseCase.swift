//
//  DrawUseCase.swift
//  Drawing
//
//  Created by ByungHoon Ann on 2023/11/12.
//

import UIKit

protocol DrawingUseCase {
    func makeRectangle(drawRect: DrawingRect) -> DrawingInfo
    func startDraw(drawPoint: DrawPoint)
    func makingDraw(drawPoint: DrawPoint) -> DrawingInfo
    func endDraw() -> DrawingInfo
}

final class DrawingUseCaseImpl: DrawingUseCase {
    
    private let width: Float = 100
    private let height: Float = 100
    
    private let fakeBezierPath = BezierPathManager()
    
    func makeRectangle(drawRect: DrawingRect) -> DrawingInfo {
        return DrawingInfo(id: makeDrawingID(),
                           rect: makeRectangleFrame(drawRect: drawRect),
                           color: makeRandomColor(),
                           drawingType: .rectangle)
    }
                      
    func startDraw(drawPoint: DrawPoint) {
        fakeBezierPath.move(to: drawPoint)
    }
    
    func makingDraw(drawPoint: DrawPoint) -> DrawingInfo {
        fakeBezierPath.addLine(to: drawPoint)
        return fakeBezierPath.makeDrawingInfo()
    }
    
    func endDraw() -> DrawingInfo {
        return fakeBezierPath.makeDrawingInfo()
    }
    
    private func makeRandomColor() -> DrawingRGB {
        let color = UIColor.randomColor
        guard color != UIColor.systemRed else { return makeRandomColor() }
        return color.drawingColor()
    }
    
    private func makeRectangleFrame(drawRect: DrawingRect) -> DrawingRect {
        let maxWidth = drawRect.width - 100
        let maxHeight = drawRect.height - 100
        let originX = Float.random(in: 0...maxWidth)
        let originY = Float.random(in: 0...maxHeight)
        
        return DrawingRect(x: originX, y: originY, width: width, height: height)
    }
    
    private func makeDrawingID() -> String {
        return UUID().uuidString
    }
}
