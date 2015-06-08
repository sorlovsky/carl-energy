//
//  ProductionViewController.swift
//  Energy
//
//  Created by Simon Orlovsky on 5/8/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

class ProductionViewController: UIViewController {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var punchLineLabel: UILabel!
    
    
    var producedVal: Double = 0
    var gridVal: Double = 0
    
    var counter: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        grabPercentTotalCampusUse()
        
        
    }
    
    
    func updateLabel(results: [String: Double]) {
        if let value = results["carleton_wind_production"] {
            self.producedVal = value
        }
        if let value = results["carleton_campus_en_use"] {
            self.gridVal = value
        }
        if producedVal * gridVal != 0 {
            println("Setting the label text")
            dispatch_async(dispatch_get_main_queue()){
                var percent = (self.producedVal)/(self.gridVal+self.producedVal)*100
                self.punchLineLabel.text = "\(round(percent*100)/100)%"
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue()){
                self.punchLineLabel.text = "0%"
            }
        }
    }
    
    func grabPercentTotalCampusUse(){
        let data: DataRetreiver = DataRetreiver()
        let date: NSDate = NSDate()
        data.fetchCurrent("carleton_wind_production", callback: updateLabel)
        data.fetchCurrent("carleton_campus_en_use", callback: updateLabel)
    }
}
