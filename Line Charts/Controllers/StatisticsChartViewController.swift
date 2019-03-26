//
//  StatisticsChartViewController.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/18/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

class StatisticsChartViewController: UITableViewController {
    
    // MARK: - Properties
    var chart = [ChartLine]()
    private var removedLines = [Int: ChartLine]()
    
    // MARK: - Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? chart.count + 1 : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            if !(indexPath.row > 0) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableIdentifier.chart, for: indexPath) as? ChartCell else { return UITableViewCell() }
                
                cell.configure(chart: chart)
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableIdentifier.chartConfiguration, for: indexPath) as? ChartConfigurationCell else { return UITableViewCell() }
                
                cell.imageView?.image = cell.imageView?.image?.withRenderingMode(.alwaysTemplate)
                cell.imageView?.tintColor = chart[indexPath.row - 1].color
                cell.textLabel?.text = chart[indexPath.row - 1].name
                
                return cell
            }
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableIdentifier.theme, for: indexPath) as? ThemeCell else { return UITableViewCell() }
            
            cell.textLabel?.text = "Switch theme bro"
            cell.textLabel?.textAlignment = .center
            
            return cell
            
        default:
            break
            
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        guard let chartCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? ChartCell else { return }
        
        let index = indexPath.row - 1
        
        selectedCell.isSelected = false
        
        switch indexPath.section {
        case 0:
            
            if indexPath.row > 0 {
                switch selectedCell.accessoryType {
                    
                case .none:
                    selectedCell.accessoryType = .checkmark
                    
                    if chart.count > index {
                        chart.insert(removedLines[index]!, at: index)
                        chartCell.add(removedLines.removeValue(forKey: index)!, at: index, isInsert: true)
                    } else {
                        chart.append(removedLines[index]!)
                        chartCell.add(removedLines.removeValue(forKey: index)!, at: chart.count - 1, isInsert: false)
                    }
                    
                case .checkmark:
                    selectedCell.accessoryType = .none
                    
                    removedLines[index] = chart.remove(at: [index, chart.count].getValidIndex())
                    chartCell.remove(at: [index, chart.count + 1].getValidIndex())
                    
                default:
                    break
                    
                }
            }
            
        case 1:
            
            print("Change theme!")
            
        default:
            break
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath == IndexPath(row: 0, section: 0) ? 400 : 50
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "FOLLOWERS"
    }
    
}
