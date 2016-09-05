//
//  GraphViewController.swift
//  Calculator
//
//  Created by Johnson Zhou on 01/09/2016.
//  Copyright © 2016 Johnson Zhou. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    var computeYForX: ((Double) -> Double)? {
        didSet {
            graphView?.computeYForX = computeYForX
        }
    }
    var numberFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.maximumSignificantDigits = 3
        
        graphView.computeYForX = computeYForX

        if var string = funcDescription {
            string.remove(at: string.index(before: string.endIndex))
            string = "y=" + string
            functionDescription.text = string
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        graphView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchView)))
            graphView.addGestureRecognizer(UITapGestureRecognizer(target: graphView, action: #selector(graphView.doubleTap)))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(graphView.panView)))
            graphView.computeYForX = computeYForX
        }
    }
    @IBAction func slider(_ scaleSlider: UISlider) {
        let value = pow(10, CGFloat(scaleSlider.value + 1))
        
        graphView.rangeX = value
        graphView.rangeY = value
        
        scaleLabel.text = numberFormatter.string(from: NSNumber(value: Double(value)))
    }
    
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

    @IBAction func defaultScale() {

        slider.value = 0
        let value = pow(10, CGFloat(slider.value + 1))

        graphView.rangeX = value
        graphView.rangeY = value
        
        scaleLabel.text = numberFormatter.string(from: NSNumber(value: Double(value)))
    }
    
    func pinchView(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            graphView.rangeX *= recognizer.scale
            graphView.rangeY *= recognizer.scale
            recognizer.scale = 1.0
            scaleLabel.text = numberFormatter.string(from: NSNumber(value: Double(graphView.rangeX)))
            graphView.setNeedsDisplay()
        default:
            break
        }
    }

    @IBOutlet weak var functionDescription: UILabel!
    
    var funcDescription: String? {
        didSet {
            
        }
    }

    
    
}
