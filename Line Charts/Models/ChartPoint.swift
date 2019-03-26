//
//  ChartPoint.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/26/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import Foundation

struct ChartPoint {
    var x: Double
    var y: Double
}

extension ChartPoint: Equatable {
    
    static func == (lhs: ChartPoint, rhs: ChartPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
}
