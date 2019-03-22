//
//  ChartCell.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/18/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

class ChartCell: UITableViewCell {
    
    // MARK: - Properties
    private var initialDetailsConstraint: CGFloat!
    
    // MARK: - IBOutlets
    @IBOutlet private weak var chartView: ChartView!
    @IBOutlet private weak var detailsView: UIView!
    @IBOutlet private var detailsLabels: [UILabel]!
    @IBOutlet private weak var detailsConstraint: NSLayoutConstraint!

    // MARK: - Life circle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chartView.delegate = self
        initialDetailsConstraint = detailsConstraint.constant
        detailsView.alpha = 0
    }
    
    func removeLine(at index: Int, count: Int) {
        chartView.removeLine(at: [index, count].getValidIndex())
    }
    
    func add(line: ChartLine, at index: Int, count: Int) {
        if count > index {
            chartView.insert(line, at: index)
        } else {
            chartView.add(line)
        }
    }
    
    // MARK: - Configure cell
    func configure(chart: [ChartLine]) {
        drawChart(chart: chart)
    }
    
    // MARK: - Chart drawing methods
    private func drawChart(chart: [ChartLine]) {
        chart.forEach { chartView.add($0) }
        
        chartView.yLabelsFormatter = { String(Int($1)) }
        chartView.xLabelsFormatter = { Int($1).convertDateFromMilliseconds(with: "MMM dd") }
    }

}

// MARK: - Chart view delegation
extension ChartCell: ChartDelegate {
    func didTouchChart(_ chart: ChartView, valuesIndices: Array<Int?>, xValue: Double, position: CGFloat) {
        detailsView.alpha = 1
        
        for (seriesIndex, dataIndex) in valuesIndices.enumerated() {
            if let value = chart.valueForLine(seriesIndex, atIndex: dataIndex) {
                update(value: String(describing: value.rounded()), index: seriesIndex)
                detailsConstraint.constant = configureDetailsConstraint(position: position)
            }
        }
        
        update(date: xValue)
    }
    
    func didFinishTouchingChart(_ chart: ChartView) {
        hideDetailsView()
    }
    
    func didEndTouchingChart(_ chart: ChartView) {
        hideDetailsView()
    }
    
    // MARK: - Chart delegation helpers
    private func configureDetailsConstraint(position: CGFloat) -> CGFloat {
        var constant = initialDetailsConstraint + position - (detailsView.frame.width / 2)
        
        if constant < initialDetailsConstraint {
            constant = initialDetailsConstraint
        }
        
        let rightMargin = chartView.frame.width - detailsView.frame.width + initialDetailsConstraint + 1
        if constant > rightMargin {
            constant = rightMargin
        }
        
        return constant
    }
    
    private func update(date: Double) {
        for label in detailsLabels {
            switch label.tag {
                
            case 0:
                label.text = Int(date).convertDateFromMilliseconds(with: "MMM dd")
            case 1:
                label.text = Int(date).convertDateFromMilliseconds(with: "yyyy")
            default:
                break
                
            }
        }
    }
    
    private func update(value: String, index: Int) {
        for label in detailsLabels {
            switch label.tag {
                
            case 2 where index == 0:
                label.text = value
            case 3 where index == 1:
                label.text = value
            default:
                break
                
            }
        }
    }
    
    private func hideDetailsView() {
        detailsView.alpha = 0
        detailsConstraint.constant = initialDetailsConstraint
    }
}
