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
            resolution = 0.05 * Double(rangeX / 10.0)
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
    
    /*
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
    } */
    
    fileprivate func drawCoordinateSystem() {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.maximumSignificantDigits = 3
        var segmentInterval = rangeX / interval
        var position = origin!
        
        var accumulator = CGFloat(0.0) //-(origin.x - graphCenter.x) / bounds.maxX * 2 * rangeX
        
        if (origin.y <= bounds.maxY) && (origin.y >= bounds.minY) {
            while position.x >= bounds.minX {
                getXLineSeg(point: position).stroke()
                position.x -= segmentLengthX
                
                let rect = CGRect(x: position.x + segmentLengthX, y: position.y + 5, width: 40, height: 20)
                let label = UILabel(frame: rect)
                label.text = numberFormatter.string(from: NSNumber(value: Double(accumulator)))
                numberLabel.append(label)
                label.isHidden = false
                label.font = UIFont.systemFont(ofSize: 12)
                addSubview(label)
                //print("Label \(label.text!) added!")
                accumulator -= segmentInterval
            }
            accumulator += segmentInterval

            minX = Double(accumulator + (position.x - bounds.minX) / (bounds.width / 2) * rangeX)
            
            position.x = origin.x + segmentLengthX
            accumulator = segmentInterval
            
            while position.x <= bounds.maxX {
                
                getXLineSeg(point: position).stroke()
                position.x += segmentLengthX
                
                let rect = CGRect(x: position.x - segmentLengthX, y: position.y + 5, width: 40, height: 20)
                let label = UILabel(frame: rect)
                label.text = numberFormatter.string(from: NSNumber(value: Double(accumulator)))
                numberLabel.append(label)
                label.isHidden = false
                label.font = UIFont.systemFont(ofSize: 12)
                addSubview(label)
                //print("Label \(label.text!) added!")
                accumulator += segmentInterval
            }
            accumulator -= segmentInterval
            let diff = bounds.maxX - position.x
            let conversion = (bounds.width / 2) / rangeX
            maxX = Double(accumulator + diff / conversion)
        }
        
        
        
        if (origin.x <= bounds.maxX) && (origin.x >= bounds.minX) {
            
            position.x = origin.x
            position.y = origin.y - segmentLengthY
            accumulator = segmentInterval
            segmentInterval = rangeY / interval
            
            while position.y >= bounds.minY {
                getYLineSeg(point: position).stroke()
                position.y -= segmentLengthY
                
                let rect = CGRect(x: position.x + 5, y: position.y + segmentLengthY, width: 40, height: 20)
                let label = UILabel(frame: rect)
                label.text = numberFormatter.string(from: NSNumber(value: Double(accumulator)))
                numberLabel.append(label)
                label.isHidden = false
                label.font = UIFont.systemFont(ofSize: 12)
                addSubview(label)
                //print("Label \(label.text!) added!")
                accumulator += segmentInterval
            }
            
            accumulator -= segmentInterval
            var diff = position.y - bounds.minY
            var conversion = (bounds.height / 2) / rangeY
            maxY = Double(accumulator + diff / conversion)
            
            position.y = origin.y + segmentLengthY
            accumulator = -segmentInterval
            
            while position.y <= bounds.maxY {
                
                getYLineSeg(point: position).stroke()
                position.y += segmentLengthY
                
                let rect = CGRect(x: position.x + 5, y: position.y - segmentLengthY, width: 40, height: 20)
                let label = UILabel(frame: rect)
                label.text = numberFormatter.string(from: NSNumber(value: Double(accumulator)))
                numberLabel.append(label)
                label.isHidden = false
                label.font = UIFont.systemFont(ofSize: 12)
                addSubview(label)
                //print("Label \(label.text!) added!")
                accumulator -= segmentInterval
            }
            accumulator += segmentInterval
            diff = bounds.maxY - position.y
            conversion = bounds.height / 2 / rangeY
            print("\(diff/conversion) \(accumulator)")
            minY = Double(accumulator + diff / conversion)
        }

        print("maxX = \(maxX)")
        print("minX = \(minX)")
        print("maxY = \(maxY)")
        print("minY = \(minY)")

        
    }
    
    
    
    func doubleTap(recognizer: UITapGestureRecognizer) {
        originToCenter()
        setNeedsDisplay()
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
    
    var computeYForX: ((Double) -> Double)?
    
    var minX: Double = -10
    var maxX: Double = 10
    var minY: Double = -10
    var maxY: Double = 10
    
    fileprivate func updateMinMaxXY() {
        
    }
    
    fileprivate var resolution: Double = 0.05 //* Double(rangeX) / 10.0
    
    fileprivate func coordinateToCGPoint(x: Double, y: Double) -> CGPoint {
        let displacementX = origin.x - graphCenter.x
        let displacementY = origin.y - graphCenter.y
        let scaleX = (rangeX / bounds.width * 2)
        let scaleY = (rangeY / bounds.height * 2)
        return CGPoint(x: (CGFloat(x) + rangeX) / scaleX + displacementX, y: (CGFloat(-y) + rangeY) / scaleY + displacementY)
    }
    
    fileprivate func drawFunction() {
        
        var started = false
        updateMinMaxXY()
        let function = UIBezierPath()
        
        if let YForX = self.computeYForX {
            if !YForX(minX).isNaN {
                function.move(to: coordinateToCGPoint(x: minX, y: YForX(minX)))
                started = true
            }
            print("x: \(coordinateToCGPoint(x: minX, y: YForX(minX)).x) y: \(coordinateToCGPoint(x: minX, y: YForX(minX)).y)")
            var x = minX + resolution
            print("x=\(x) maxX=\(maxX)")
            while x < maxX {
                if !started && !YForX(x).isNaN {
                    let toPoint = coordinateToCGPoint(x: x, y: YForX(x))
                    function.move(to: toPoint)
                    started = true
                } else if !YForX(x).isNaN {
                    let toPoint = coordinateToCGPoint(x: x + resolution * 2, y: YForX(x + resolution * 2))
                    let controlPoint = coordinateToCGPoint(x: x + resolution, y: YForX(x + resolution))
                    function.addQuadCurve(to: toPoint, controlPoint: controlPoint)
                    print("to x=\(toPoint.x) y=\(toPoint.y)")
                }
                x += resolution * 2
            }
        }
        function.lineWidth = 1.0
        function.stroke()
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
        drawFunction()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        path.addQuadCurve(to: CGPoint(x: bounds.maxX, y: bounds.maxY), controlPoint: CGPoint(x: bounds.midX, y: bounds.midY))
        //path.stroke()
    }
    
    override func setNeedsDisplay() {
        for label in numberLabel {
            label.removeFromSuperview()
        }
        super.setNeedsDisplay()
    }
    
    

}
