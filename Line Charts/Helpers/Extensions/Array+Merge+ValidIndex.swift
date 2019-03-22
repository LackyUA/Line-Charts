//
//  Array+Merge+ValidIndex.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/21/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import Foundation

extension Array where Iterator.Element == (x: Double, y: Double) {
    
    mutating func merge(xValues: Array<Int>, and yValues: Array<Int>) {
        for index in xValues.indices {
            self.append((x: Double(xValues[index]), y: Double(yValues[index])))
        }
    }
    
}

extension Array where Iterator.Element == Int {
    
    func getValidIndex() -> Int {
        if self[0] < self[1] {
            return self[0]
        } else {
            for index in 0...self[1] {
                if self[0] - index < self[1] && self[1] != 0 {
                    return self[0] - index                }
            }
        }
        
        return Int()
    }
    
}
