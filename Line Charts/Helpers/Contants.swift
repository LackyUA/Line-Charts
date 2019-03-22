//
//  Contants.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/12/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

class Constants {
    
    // MARK: - JSON parsing constants
    struct jsonFile {
        static let name = "chart_data"
        static let type = "json"
    }
    
    // MARK: - Statistics Chart View Controller reusable identifier constants
    struct reusableIdentifier {
        static let chart = "ChartCell"
        static let chartConfiguration = "ChartConfigurationCell"
        static let theme = "ThemeCell"
    }
    
    // MARK: - Chart View constants
    struct colors {
        static let axesColor: UIColor = UIColor.gray.withAlphaComponent(0.5)
        static let gridColor: UIColor = UIColor.gray.withAlphaComponent(0.5)
        static let labelColor: UIColor = UIColor.gray
        static let highlightLineColor = UIColor.gray
    }
    
    struct sizes {
        static let lineWidth: CGFloat = 1.5
        static let labelPadding: CGFloat = 5.0
        static let highlightLineWidth: CGFloat = 0.5
    }
    
}
