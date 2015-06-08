//
//  ColumnGraphViewController.swift
//  Energy
//
//  Created by Caleb Braun on 6/8/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

class ColumnGraphViewController: UIViewController {
    
    var selectedBuilding:String = ""
    @IBOutlet weak var columnGraphView: ColumnGraphView!
    @IBOutlet weak var buildingNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The default is total energy
        getGraphData("month", energyType: "electricity")
    }

    func getGraphData(timePeriod: String, energyType: String) {
        self.buildingNameLabel.text = self.selectedBuilding
        let dataFetcher = DataRetreiver()
        dataFetcher.fetchOverTimePeriod(self.selectedBuilding, timePeriod: timePeriod, meterType: energyType, callback: loadGraphData)
    }
    
    func loadGraphData(results: [String: [Double]]) {
        columnGraphView.dataPoints = results[self.selectedBuilding]!
        
        dispatch_async(dispatch_get_main_queue()) {
            self.columnGraphView.setNeedsDisplay()
        }
    }


}
