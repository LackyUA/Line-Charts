//
//  String+ColorFromString.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/25/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

extension String {
    
    func convertToUIColor() -> UIColor{
        var stringColor = self
        stringColor.removeFirst()
        
        var color: UInt32 = 0
        Scanner(string: "0x" + stringColor).scanHexInt32(&color)
        
        return UIColor(rgb: Int(color))
    }
    
}
