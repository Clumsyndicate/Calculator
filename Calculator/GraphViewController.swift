//
//  GraphViewController.swift
//  Calculator
//
//  Created by Johnson Zhou on 01/09/2016.
//  Copyright © 2016 Johnson Zhou. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    var computeYForX: ((Double) -> Double)?
    var numberFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        //nav?.navigationBar.isHidden = false
        
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.maximumSignificantDigits = 3

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: #selector(graphView.pinchView)))
            graphView.addGestureRecognizer(UITapGestureRecognizer(target: graphView, action: #selector(graphView.doubleTap)))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(graphView.panView)))
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}
