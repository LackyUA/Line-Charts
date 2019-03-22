//
//  Int+ConvertDate.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/12/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

extension Int {
    
    func convertDateFromMilliseconds(with format: String) -> String {
        let date = Date(timeIntervalSince1970: Double(self) / 1000.0)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
}
