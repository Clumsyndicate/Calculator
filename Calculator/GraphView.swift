//
//  GraphView.swift
//  Calculator
//
//  Created by Johnson Zhou on 01/09/2016.
//  Copyright © 2016 Johnson Zhou. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
 
    */
    @IBInspectable
    var color: UIColor = UIColor.black
    @IBInspectable
    var lineWidth: CGFloat = 3.0
    
    fileprivate var justStarted = true
    
    //let brain: CalculatorBrain!
    var interval: CGFloat = 10.0
    
    var rangeX: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var rangeY: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    fileprivate let distanceToNumber: CGFloat = 10
    
    fileprivate var graphCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    fileprivate var origin: CGPoint!
    
    func originToCenter() {
        origin = graphCenter
    }
    
    fileprivate func getAxis() -> (xAxis: UIBezierPath, yAxis: UIBezierPath) {
        
        let xAxis = UIBezierPath()
        xAxis.move(to: CGPoint(x: 0, y: origin.y))
        xAxis.addLine(to: CGPoint(x: bounds.maxX, y: origin.y))
        xAxis.lineWidth = lineWidth
        let yAxis = UIBezierPath()
        yAxis.move(to: CGPoint(x: origin.x, y: 0))
        yAxis.addLine(to: CGPoint(x: origin.x, y: bounds.maxY))
        yAxis.lineWidth = lineWidth
        
        return (xAxis, yAxis)
    }
    
    fileprivate var segmentLengthX: CGFloat {
        return bounds.width / 2.0 / interval
    }
    
    fileprivate var segmentLengthY: CGFloat {
        return bounds.height / 2.0 / interval
    }
    
    fileprivate var markLengthX: CGFloat {
        return bounds.height / 100
    }
    
    fileprivate var markLengthY: CGFloat {
        return bounds.width / 100
    }

    fileprivate func getXLineSeg(point: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: point.x, y: point.y - markLengthX))
        path.addLine(to: CGPoint(x: point.x, y: point.y + markLengthX))
        
        return path
    }
    
    fileprivate func getYLineSeg(point: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: point.x - markLengthY, y: point.y))
        path.addLine(to: CGPoint(x: point.x + markLengthY, y: point.y))
        
        return path
    }
    
    fileprivate var numberLabel = [UILabel]()
    
    fileprivate func drawAxesSegments() {
        let segmentInterval = rangeX / interval
        var position = CGPoint(x: 0, y: bounds.midY)
        print("\(bounds.midX) \(bounds.midY)")
        var accumulator = -rangeX
        let numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.maximumSignificantDigits = 3
        var counter = 0
        
        while position.x < bounds.midX {
            getXLineSeg(point: position).stroke()
            position.x += segmentLengthX
            
            let rect = CGRect(x: position.x - 5 - segmentLengthX, y: position.y + 5, width: 40, height: 20)
            let label = UILabel(frame: rect)
            label.text = numberFormatter.string(from: NSNumber(value: Double(accumulator)))
            numberLabel.append(label)
            label.isHidden = false
            label.font = UIFont.systemFont(ofSize: 12)
            addSubview(label)
            accumulator += segmentInterval
            counter += 1
        }
        counter -= 1
        numberLabel.last?.text = String(describing: 0)
        
        position.x = bounds.maxX
        print(position.x)
        
        var count = 0
        accumulator = rangeX
        while count < counter {//(position.x > bounds.midX) && (accumulator >= segmentInterval) {
            getXLineSeg(point: position).stroke()
            position.x -= segmentLengthX
            
            let rect = CGRect(x: position.x - 5 + segmentLengthX, y: position.y + 5, width: 40, height: 20)
            let label = UILabel(frame: rect)
            label.text = numberFormatter.string(from: NSNumber(value: Double(accumulator)))
            numberLabel.append(label)
            label.isHidden = false
            label.font = UIFont.systemFont(ofSize: 12)
            addSubview(label)
            accumulator -= segmentInterval
            print(accumulator)
            count += 1
        }
        
        position = CGPoint(x: bounds.midX, y: 0)
        accumulator = -rangeY
        count = 0
        
        while count < counter {//(position.y < bounds.midY) && (accumulator <= -segmentInterval) {
            getYLineSeg(point: position).stroke()
            position.y += segmentLengthY
            
            let rect = CGRect(x: position.x + 10, y: position.y - segmentLengthY - 10, width: 40, height: 20)
            let label = UILabel(frame: rect)
            label.text = numberFormatter.string(from: NSNumber(value: Double(accumulator)))
            numberLabel.append(label)
            label.isHidden = false
            label.font = UIFont.systemFont(ofSize: 12)
            addSubview(label)
            accumulator += segmentInterval
            count += 1
        }
        
        position.y = bounds.maxY
        count = 0
        
        accumulator = rangeY
        while count < counter {//(position.y > bounds.midY) && (accumulator >= segmentInterval) {
            getYLineSeg(point: position).stroke()
            position.y -= segmentLengthY
            
            let rect = CGRect(x: position.x + 10, y: position.y + segmentLengthY - 10, width: 40, height: 20)
            let label = UILabel(frame: rect)
            label.text = numberFormatter.string(from: NSNumber(value: Double(accumulator)))
            numberLabel.append(label)
            label.isHidden = false
            label.font = UIFont.systemFont(ofSize: 12)
            addSubview(label)
            accumulator -= segmentInterval
            count += 1
        }
    }
    
    fileprivate func drawCoordinateSystem() {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.maximumSignificantDigits = 3
        let segmentInterval = rangeX / interval
        var position = CGPoint(x: 0, y: origin.y)
        var accumulator = -rangeX - (origin.x - graphCenter.x) / bounds.maxX * 2 * rangeX
        var counter = 0
        
        if (origin.y <= bounds.maxY) && (origin.y >= bounds.minY) {
            while position.x < bounds.midX {
                getXLineSeg(point: position).stroke()
                position.x += segmentLengthX
                
                let rect = CGRect(x: position.x - 5 - segmentLengthX, y: position.y + 5, width: 40, height: 20)
                let label = UILabel(frame: rect)
                label.text = numberFormatter.string(from: NSNumber(value: Double(accumulator)))
                numberLabel.append(label)
                label.isHidden = false
                label.font = UIFont.systemFont(ofSize: 12)
                addSubview(label)
                accumulator += segmentInterval
                counter += 1
            }
            
            counter -= 1
            numberLabel.last?.text = String(describing: 0)
            
            position.x = bounds.maxX
            print(position.x)
            
            var count = 0
            accumulator = rangeX - (origin.x - graphCenter.x) / bounds.maxX * 2 * rangeX
            while count < counter {//(position.x > bounds.midX) && (accumulator >= segmentInterval) {
                getXLineSeg(point: position).stroke()
                position.x -= segmentLengthX
                
                let rect = CGRect(x: position.x - 5 + segmentLengthX, y: position.y + 5, width: 40, height: 20)
                let label = UILabel(frame: rect)
                label.text = numberFormatter.string(from: NSNumber(value: Double(accumulator)))
                numberLabel.append(label)
                label.isHidden = false
                label.font = UIFont.systemFont(ofSize: 12)
                addSubview(label)
                accumulator -= segmentInterval
                print(accumulator)
                count += 1
            }
        }
        
        if (origin.x <= bounds.maxX) && (origin.x >= bounds.minX) {
            
        }

        
    }
    
    func pinchView(recognizer: UIPinchGestureRecognizer) {
        
    }
    
    func doubleTap(recognizer: UITapGestureRecognizer) {
        
    }
    
    func panView(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            let translation = recognizer.translation(in: self)
            origin.x += translation.x
            origin.y += translation.y
            recognizer.setTranslation(CGPoint(x: 0,y: 0), in: self)
            setNeedsDisplay()
        default: break
        }
    }
    
    fileprivate func drawFunction() {
        
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if justStarted {
            originToCenter()
            justStarted = false
            print("started")
        }
        
        color.set()
        
        let Axes = getAxis()
        Axes.xAxis.stroke()
        Axes.yAxis.stroke()
        
        // drawAxesSegments()
        drawCoordinateSystem()
        
    }
    
    override func setNeedsDisplay() {
        for label in numberLabel {
            label.removeFromSuperview()
        }
        super.setNeedsDisplay()
    }
    
    

}
