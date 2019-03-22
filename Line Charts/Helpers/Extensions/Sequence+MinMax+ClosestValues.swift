//
//  Sequence+MinMax+ClosestValues.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/21/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element == Double {
    
    func minOrZero() -> Double {
        return self.min() ?? 0.0
    }
    
    func maxOrZero() -> Double {
        return self.max() ?? 0.0
    }
    
    func getClosestValues(forValue value: Double)
        -> (lowest: (index: Int?, value: Double?), highest: (index: Int?, value: Double?))
    {
        var lowest: (index: Int?, value: Double?)
        var highest: (index: Int?, value: Double?)
        
        self.enumerated().forEach { (index, currentValue) in
            if currentValue <= value && (lowest.value == nil || lowest.value! < currentValue) {
                lowest.value = currentValue
                lowest.index = index
            }
            if currentValue >= value && (highest.value == nil || highest.value! > currentValue) {
                highest.value = currentValue
                highest.index = index
            }
        }
        
        return (lowest: lowest, highest: highest)
    }
    
}
