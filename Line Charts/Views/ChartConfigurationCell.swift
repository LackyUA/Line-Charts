//
//  ChartConfigurationCell.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/18/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

class ChartConfigurationCell: UITableViewCell {
    
    func configure(_ chart: ChartLine) {
        imageView?.image = imageView?.image?.withRenderingMode(.alwaysTemplate)
        imageView?.tintColor = chart.color
        textLabel?.text = chart.name
    }
    
}
