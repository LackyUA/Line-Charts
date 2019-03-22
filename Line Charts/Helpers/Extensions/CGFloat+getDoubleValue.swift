//
//  CGFloat+getDoubleValue.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/22/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

extension CGFloat {
    
    func getDoubleValue(min: Double, max: Double, drawingSize: CGFloat) -> Double {
        return ((max - min) / Double(drawingSize)) * Double(self) + min
    }
    
}
