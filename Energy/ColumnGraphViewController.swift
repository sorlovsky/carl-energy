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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The default is total energy
        getGraphData("month", energyType: "electricity")
    }

    func getGraphData(timePeriod: String, energyType: String) {
        let dataFetcher = DataRetreiver()
        // dataFetcher.fetchSingle
    }
    


}
