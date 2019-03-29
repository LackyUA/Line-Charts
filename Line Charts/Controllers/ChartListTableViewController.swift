//
//  ChartListTableViewController.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/18/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

class ChartListTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var charts = [ChartData]()
    private var reusableIdentifier = "OptionCell"
    
    // MARK: - Constants
    private let parser = Parser()

    // MARK: - Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.parser.getDataFromFile { [weak self] charts in
                self?.charts = charts
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath)

        cell.textLabel?.text = "\(indexPath.row + 1) Chart"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StatisticsController") as? StatisticsChartViewController else { return }
        
        destinationVC.chart = getChartLinesFor(chart: charts[indexPath.row])
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // MARK: - Helper functions
    private func getChartLinesFor(chart: ChartData) -> [ChartLine] {
        var chartLines = [ChartLine]()
        
        chart.columns.forEach { args in
            if args.key != "x" {
                var lineData = [(x: Double, y: Double)]()
                
                guard let stringColor = chart.colors[args.key] else { return }
                let lineColor = stringColor.convertToUIColor()
                
                guard let lineName = chart.names[args.key] else { return }
                
                guard let lineXValues = chart.columns["x"] else { return }
                guard let lineYValues = chart.columns[args.key] else { return }
                
                lineData.merge(xValues: lineXValues, and: lineYValues)
                
                chartLines.append(ChartLine(
                    data: lineData,
                    color: lineColor,
                    name: lineName
                ))
            }
        }
        
        return chartLines.sorted(by: { $0.name < $1.name })
    }

}
