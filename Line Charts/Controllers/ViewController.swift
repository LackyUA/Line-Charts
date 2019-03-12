//
//  ViewController.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/11/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var charts = [ChartData]()
    private let parser = Parser()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        parser.getDataFromFile(completion: { charts in
            self.charts = charts
            self.printParseResult(charts: self.charts)
        })
    }
    
    private func printParseResult(charts: [ChartData]) {
        for chart in self.charts {
            print(chart.names)
            print(chart.colors)
            print(chart.types)
            
            chart.columns.forEach {
                print("Values of \($0.key):")
                
                if $0.key == "x" {
                    for value in $0.value {
                        print(value.convertDateFromMilliseconds(with: "yyyy-MM-dd HH:mm:ss"))
                    }
                } else {
                    for value in $0.value {
                        print(value)
                    }
                }
            }
        }
    }

}
