//
//  ChartLine.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/15/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

protocol Line: AnyObject {
    associatedtype Point
    
    var data: [(x: Double, y: Double)] { get set }
    var color: UIColor { get }
    var name: String { get }
    
    func divideIntoSegments() -> [[Point]]
    func getMarginals(min: inout Point, max: inout Point)
}

final class ChartLine: NSObject, Line {
    
    // MARK: - Properties
    var data: [(x: Double, y: Double)]
    var color: UIColor
    var name: String
    
    // MARK: - Initializers
    required init(data: [(x: Double, y: Double)], color: UIColor, name: String) {
        self.data = data
        self.color = color
        self.name = name
    }

    convenience init(data: [(x: Float, y: Float)], color: UIColor, name: String) {
        self.init(data: data.map { (Double($0.x), Double($0.y)) }, color: color, name: name)
    }

    convenience init(data: [(x: Int, y: Int)], color: UIColor, name: String) {
        self.init(data: data.map { (Double($0.x), Double($0.y)) }, color: color, name: name)
    }
    
    // MARK: - Methods for division of the line into segments
    func divideIntoSegments() -> [[(x: Double, y: Double)]] {
        var segments: [[Point]] = []
        var segment: [Point] = []
        
        self.data.enumerated().forEach { (index, point) in
            segment.append(point)
            
            if index < self.data.count - 1 {
                // Add the end of segment
                let nextPoint = self.data[index + 1]
                segment.append(nextPoint)
                segments.append(segment)
                
                // Start a new segment
                segment = [nextPoint]
            } else {
                // End of the line
                segments.append(segment)
            }
        }
        
        return segments
    }
    
    // MARK: - Method for geting min/max points
    func getMarginals(min: inout (x: Double, y: Double), max: inout (x: Double, y: Double)) {
        min.x = min.x < self.data.map { $0.x }.minOrZero() ? min.x : self.data.map { $0.x }.minOrZero()
        min.y = min.y < self.data.map { $0.y }.minOrZero() ? min.y : self.data.map { $0.y }.minOrZero()
        max.x = max.x > self.data.map { $0.x }.maxOrZero() ? max.x : self.data.map { $0.x }.maxOrZero()
        max.y = max.y > self.data.map { $0.y }.maxOrZero() ? max.y : self.data.map { $0.y }.maxOrZero()
    }
    
}
