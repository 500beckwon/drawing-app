//
//  DrawingModels.swift
//  Drawing
//
//  Created by ByungHoon Ann on 2023/11/13.
//

import Foundation

protocol DrawingInformation {
    var id: String { get }
    var rect:  DrawingRect { get }
    var color: DrawingRGB { get }
    var drawingType: DrawingType { get }
    var isMine: Bool { get }
    var pathInfo: DrawingPathInfo? { get set }
}

struct DrawingInfo: DrawingInformation, Codable {
    let id: String
    let rect: DrawingRect
    let color: DrawingRGB
    let drawingType: DrawingType
    let isMine: Bool
    var pathInfo: DrawingPathInfo?
    
    init(id: String,
         rect: DrawingRect = .zero,
         color: DrawingRGB,
         drawingType: DrawingType,
         isMine: Bool = true,
         pathInfo: DrawingPathInfo? = nil) {
        self.id = id
        self.rect = rect
        self.color = color
        self.drawingType = drawingType
        self.isMine = isMine
        self.pathInfo = pathInfo
    }
}

struct DrawingRect: Codable {
    let x: Float
    let y: Float
    let width: Float
    let height: Float
    
    var point: DrawPoint {
        return DrawPoint(x: x, y: y)
    }
    
    static var zero: DrawingRect {
        return DrawingRect(x: 0, y: 0, width: 0, height: 0)
    }
}

struct DrawPoint: Codable {
    let x: Float
    let y: Float
    
    static let zero = DrawPoint(x: 0, y: 0)
}

struct DrawingRGB: Codable {
    let red: Float
    let blue: Float
    let green: Float
    let alpha: Float
    
    static var clear: DrawingRGB {
        return DrawingRGB(red: 0, blue: 0, green: 0, alpha: 0)
    }
}

struct DrawingPathInfo: Codable {
    var startPoint: DrawPoint
    var pathPoint: [DrawPoint]
    var bounds: DrawingRect
    let id: String
    
    init(id: String = UUID().uuidString,
         bounds: DrawingRect = .zero,
         startPoint: DrawPoint = .zero,
         pathPoint: [DrawPoint] = []) {
        self.id = id
        self.bounds = bounds
        self.startPoint = startPoint
        self.pathPoint = pathPoint
    }
}

enum DrawingType: Codable {
    case rectangle
    case line
}

