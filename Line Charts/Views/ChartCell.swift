//
//  ChartCell.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/18/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

protocol ChartCellControllers {
    func remove(at index: Int)
    func add(_ line: ChartLine, at index: Int, isInsert: Bool)
}

class ChartCell: UITableViewCell {
    
    // MARK: - Properties
    private var initialDetailsConstraint: CGFloat!
    private var chartLines: [ChartLine] = []
    
    // MARK: - IBOutlets
    @IBOutlet private var detailsDateLabels: [UILabel]!
    @IBOutlet private var detailsValueLabels: [UILabel]!
    
    @IBOutlet private weak var chartView: ChartView!
    
    @IBOutlet private weak var detailsView: UIView!
    @IBOutlet private weak var detailsConstraint: NSLayoutConstraint!

    // MARK: - Life circle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chartView.delegate = self
        initialDetailsConstraint = detailsConstraint.constant
        
        detailsView.alpha = 0
        detailsValueLabels.forEach { $0.isHidden = true }
    }
    
    // MARK: - Configure cell
    func configure(chart: [ChartLine]) {
        self.chartLines = chart
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
        if self.chartLines.count > 0 {
            detailsView.alpha = 1
        }
        
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
        for label in detailsDateLabels {
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
        for label in detailsValueLabels {
            if index == label.tag {
                label.isHidden = false
                label.text = value
                label.textColor = chartLines[index].color
            }
        }
    }
    
    private func hideDetailsView() {
        detailsView.alpha = 0
        detailsConstraint.constant = initialDetailsConstraint
    }
    
}

// MARK: - ChartCellControllers delegation
extension ChartCell: ChartCellControllers {
    
    func remove(at index: Int) {
        detailsValueLabels[chartLines.count - 1].isHidden = true
        chartView.removeLine(at: index)
        chartLines.remove(at: index)
    }
    
    func add(_ line: ChartLine, at index: Int, isInsert: Bool) {
        if isInsert {
            chartLines.insert(line, at: index)
            chartView.insert(line, at: index)
            showLabel(at: index)
        } else {
            chartLines.append(line)
            chartView.add(line)
            showLabel(at: index)
        }
    }
    
    // MARK: - Helpers
    private func showLabel(at index: Int) {
        detailsValueLabels.forEach { label in
            if label.tag == index {
                label.isHidden = false
            }
        }
    }
    
}
