//
//  BezierPathManager.swift
//  Drawing
//
//  Created by dev dfcc on 12/19/23.
//

import UIKit

final class BezierPathManager: BezierPathProtocol {
    private lazy var bezierPath = UIBezierPath()
    private lazy var bezierPathInfo = DrawingPathInfo()
    
    var bounds: DrawingRect {
        bezierPathInfo.bounds
    }
    
    var id: String {
        bezierPathInfo.id
    }
    
    var info: DrawingPathInfo {
        return bezierPathInfo
    }
    
    func move(to point: DrawPoint) {
        bezierPath = UIBezierPath()
        bezierPathInfo = DrawingPathInfo()
        bezierPath.move(to: point)
        bezierPathInfo.startPoint = point
    }
    
    func addLine(to point: DrawPoint) {
        bezierPath.addLine(to: point)
        bezierPathInfo.pathPoint.append(point)
        bezierPathInfo.bounds = bezierPath.bounds.convertDrawingRect()
    }
    
    func makeDrawingInfo() -> DrawingInfo {
        return DrawingInfo(id: id,
                           rect: bounds,
                           color: .clear,
                           drawingType: .line,
                           pathInfo: bezierPathInfo)
    }
}
