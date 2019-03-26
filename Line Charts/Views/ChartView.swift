//
//  ChartView.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/15/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

protocol ChartDelegate {
    func didTouchChart(_ chart: ChartView, valuesIndices: [Int?], xValue: Double, position: CGFloat)
    func didFinishTouchingChart(_ chart: ChartView)
    func didEndTouchingChart(_ chart: ChartView)
}

class ChartView: UIControl {
    
    // MARK: - Private properties
//    private typealias ChartPoint = (x: Double, y: Double)
    private typealias ChartLineSegment = [ChartPoint]
    
    private var highlightShapeLayer: CAShapeLayer!
    private var layerStore: [CAShapeLayer] = []
    
    private var drawingHeight: CGFloat!
    private var drawingWidth: CGFloat!
    
    private var min: ChartPoint!
    private var max: ChartPoint!
    
    private var lines: [ChartLine] = [] {
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }
    
    // MARK: - Options
    var identifier: String?
    
    // MARK: - Insets options
    var bottomInset: CGFloat = 20
    var topInset: CGFloat = 20
    
    // MARK: - Labels options
    var labelFont: UIFont? = UIFont.systemFont(ofSize: 12)
    
    var xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
        String(Int(labelValue))
    }
    var yLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
        String(Int(labelValue))
    }
    
    // MARK: - Delegation
    var delegate: ChartDelegate?
    
    // MARK: initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    convenience init() {
        self.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        contentMode = .redraw
    }
    
    // MARK: - Chart line appearance methods
    func add(_ lines: ChartLine...) {
        lines.forEach { self.lines.append($0) }
    }
    
    func insert(_ line: ChartLine, at index: Int) {
        self.lines.insert(line, at: index)
    }
    
    func removeLine(at index: Int) {
        self.lines.remove(at: index)
    }
    
    func removeAllLines() {
        self.lines.removeAll()
    }
    
    func valueForLine(_ lineIndex: Int, atIndex dataIndex: Int?) -> Double? {
        return dataIndex != nil ? self.lines[lineIndex].data[dataIndex!].y : nil
    }
    
    // MARK: - Life circle
    override func draw(_ rect: CGRect) {
        initializeProperties()
        drawChart()
    }
    
    private func initializeProperties() {
        drawingHeight = bounds.height - bottomInset - topInset
        drawingWidth = bounds.width
        
        highlightShapeLayer = nil
        
        guard let line = lines.first else {
            min = ChartPoint(x: 0, y: 0)
            max = ChartPoint(x: 0, y: 0)
            
            return
        }
        
        min = ChartPoint(x: line.data.map { $0.x }.minOrZero(), y: line.data.map { $0.y }.minOrZero())
        max = ChartPoint(x: line.data.map { $0.x }.maxOrZero(), y: line.data.map { $0.y }.maxOrZero())
        
        for line in self.lines {
            line.getMarginals(min: &min, max: &max)
        }
    }
    
    private func cleanLayerStore() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        for layer in layerStore {
            layer.removeFromSuperlayer()
        }
        layerStore.removeAll()
    }
    
    // MARK: - Draw methods
    private func drawChart() {
        cleanLayerStore()
        
        for (index, line) in self.lines.enumerated() {
            let segments = line.divideIntoSegments()
            
            segments.forEach({ segment in
                let scaledXValues = scaleValuesOnXAxis( segment.map { $0.x } )
                let scaledYValues = scaleValuesOnYAxis( segment.map { $0.y } )
                
                drawLine(x: scaledXValues, y: scaledYValues, lineIndex: index)
            })
        }
        
        drawAxes()
        addXAxisLabels()
        addYAxisLabelsAndDrawGrid()
    }
    
    fileprivate func drawLine(x xValues: [Double], y yValues: [Double], lineIndex: Int) {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: CGFloat(xValues.first!), y: CGFloat(yValues.first!)))
        
        for index in yValues.indices where index > 0 {
            path.addLine(to: CGPoint(x: CGFloat(xValues[index]), y: CGFloat(yValues[index])))
        }
        
        let lineLayer = CAShapeLayer()
        
        lineLayer.frame = self.bounds
        lineLayer.path = path
        lineLayer.strokeColor = lines[lineIndex].color.cgColor
        lineLayer.fillColor = nil
        lineLayer.lineWidth = Constants.sizes.lineWidth
        
        self.layer.addSublayer(lineLayer)
        layerStore.append(lineLayer)
    }
    
    fileprivate func drawAxes() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(Constants.colors.axesColor.cgColor)
        context.setLineWidth(0.5)
        
        // horizontal axis at the bottom
        context.move(to: CGPoint(x: CGFloat(0), y: drawingHeight + topInset))
        context.addLine(to: CGPoint(x: CGFloat(drawingWidth), y: drawingHeight + topInset))
        context.strokePath()
        
        // vertical axis on the left
        context.move(to: CGPoint(x: CGFloat(0), y: CGFloat(0)))
        context.addLine(to: CGPoint(x: CGFloat(0), y: drawingHeight + topInset))
        context.strokePath()
    }
    
    fileprivate func addXAxisLabels() {
        guard let line = lines.first?.data else { return }
        
        let step = Int(line.count / 4 - 1)
        var index = 0
        var labels = [Double]()
        
        for _ in 0..<5 {
            labels.append(line[index].x)
            index += step
        }
        
        let scaled = scaleValuesOnXAxis(labels)
        let padding: CGFloat = 5
        
        scaled.enumerated().forEach { (index, value) in
            let label = addLabel(withText: xLabelsFormatter(index, labels[index]), at: CGPoint(x: CGFloat(value), y: drawingHeight))
            
            // Center label vertically
            label.frame.origin.y += topInset
            // Add left padding
            label.frame.origin.y -= (label.frame.height - bottomInset) / 2
            label.frame.origin.x += padding
            // Set label's text alignment
            label.frame.size.width = (drawingWidth / CGFloat(labels.count)) - padding * 2
            
            self.addSubview(label)
        }
    }
    
    fileprivate func addYAxisLabelsAndDrawGrid() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(Constants.colors.gridColor.cgColor)
        context.setLineWidth(0.5)
        
        var labels = [min.y]
        let step = (max.y - min.y) / 5

        for _ in 0..<5 {
            if labels.last != nil {
                labels.append(labels.last! + step)
            }
        }
        
        let scaled = scaleValuesOnYAxis(labels)
        
        scaled.enumerated().forEach { (index, value) in
            let y = CGFloat(value)
            
            if y != drawingHeight + topInset {
                context.move(to: CGPoint(x: CGFloat(0), y: y))
                context.addLine(to: CGPoint(x: self.bounds.width, y: y))
                context.strokePath()
            }
            
            let label = addLabel(withText: yLabelsFormatter(index, labels[index]), at: CGPoint(x: Constants.sizes.labelPadding, y: y))
            
            label.frame.origin.y -= label.frame.height
            
            self.addSubview(label)
        }
        
        UIGraphicsEndImageContext()
    }
    
    private func addLabel(withText text: String, at origin: CGPoint) -> UILabel {
        let label = UILabel(frame: CGRect(x: origin.x, y: origin.y, width: 0, height: 0))
        
        label.text = text
        label.font = labelFont
        label.textColor = Constants.colors.labelColor
        label.sizeToFit()
        
        return label
    }
    
    fileprivate func drawHighlightLineFrom(_ left: CGFloat) {
        if let shapeLayer = highlightShapeLayer {
            // Use line already created
            let path = CGMutablePath()
            
            path.move(to: CGPoint(x: left, y: 0))
            path.addLine(to: CGPoint(x: left, y: drawingHeight + topInset))
            shapeLayer.path = path
        } else {
            // Create the line
            let path = CGMutablePath()
            
            path.move(to: CGPoint(x: left, y: CGFloat(0)))
            path.addLine(to: CGPoint(x: left, y: drawingHeight + topInset))
            
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.frame = self.bounds
            shapeLayer.path = path
            shapeLayer.strokeColor = Constants.colors.highlightLineColor.cgColor
            shapeLayer.fillColor = nil
            shapeLayer.lineWidth = Constants.sizes.highlightLineWidth
            
            highlightShapeLayer = shapeLayer
            layer.addSublayer(shapeLayer)
            layerStore.append(shapeLayer)
        }
    }
    
    // MARK: - Scale methods
    private func scaleValuesOnXAxis(_ values: [Double]) -> [Double] {
        return values.map { value in
            getFactorValue(for: min.x, and: max.x, with: Double(drawingWidth)) * (value - self.min.x)
        }
    }
    
    private func scaleValuesOnYAxis(_ values: [Double]) -> [Double] {
        return values.map { value in
            Double(self.topInset) + Double(drawingHeight) - getFactorValue(for: min.y, and: max.y, with: Double(drawingHeight)) * (value - self.min.y)
        }
    }
    
    private func getFactorValue(for min: Double, and max: Double, with size: Double) -> Double {
        return max - min == 0 ? 0 : size / (max - min)
    }
    
    // MARK: - Touch event handlers
    func handleTouchEvents(_ touches: Set<UITouch>, event: UIEvent!) {
        let point = touches.first!
        let position = point.location(in: self).x
        let x = position.getDoubleValue(min: min.x, max: max.x, drawingSize: drawingWidth)
        
        if position < 0 || position > (drawingWidth as CGFloat) {
            // Remove highlight line at the end of the touch event
            if let shapeLayer = highlightShapeLayer {
                shapeLayer.path = nil
            }
            
            delegate?.didFinishTouchingChart(self)
            return
        }
        
        drawHighlightLineFrom(position)
        
        if delegate == nil { return }
        
        var indices: [Int?] = []
        
        for line in self.lines {
            var index: Int? = nil
            let closest = line.data.map({ $0.x }).getClosestValues(forValue: x)
            
            if closest.lowest.index != nil && closest.highest.index != nil {
                index = closest.lowest.index
            }
            indices.append(index)
        }
        
        delegate!.didTouchChart(self, valuesIndices: indices, xValue: x, position: position)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches, event: event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches, event: event)
        
        if let shapeLayer = highlightShapeLayer {
            shapeLayer.path = nil
        }
        
        delegate?.didEndTouchingChart(self)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches, event: event)
    }
    
}
