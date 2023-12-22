//
//  UIBezierPath+Extension.swift
//  Drawing
//
//  Created by ByungHoon Ann on 2023/11/16.
//

import UIKit

protocol BezierPathProtocol {
    func move(to point: DrawPoint)
    func addLine(to point: DrawPoint)
    func makeDrawingInfo() -> DrawingInfo
}

extension UIBezierPath {
    func move(to point: DrawPoint) {
        move(to: CGPoint(x: CGFloat(point.x), y: CGFloat(point.y)))
    }
    
    func addLine(to point: DrawPoint) {
        addLine(to: CGPoint(x: CGFloat(point.x), y: CGFloat(point.y)))
    }
}
