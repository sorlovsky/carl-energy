//
//  DetailConsumptionViewController.swift
//  Energy
//
//  Created by Simon Orlovsky on 5/10/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

class DetailConsumptionViewController: UIViewController {
    
    var selectedBuildings = [String]()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var barGraphView: BarGraphView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stringRepresentation = "-".join(selectedBuildings)
        titleLabel.text = stringRepresentation as String
        
        
        
        // Sample date data
        let dateComponents = NSDateComponents()
        dateComponents.year = 2015
        dateComponents.month = 05
        dateComponents.day = 11
        let startDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        dateComponents.day = 17
        let endDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        
        let data : DataRetreiver = DataRetreiver()
        
        // Fetches the data.  When the data is retreived it calls setupGraphDisplay()
        
        // For now let's just focus on electricity
        for building in selectedBuildings {
            var searchName = "carleton_\(selectedBuildings[0].lowercaseString)"
            searchName = searchName.componentsSeparatedByString(" ")[0]
            searchName = searchName + "_en_use"
            data.fetch(searchName, startDate: startDate, endDate: endDate, resolution: "day", callback: setupGraphDisplay)
        }
            
    }
    
    
    
    func setupGraphDisplay(results:NSArray) {
        let dataArray = results as [Double]
        
        //Use 7 days for graph - can use any number,
        //but labels and sample data are set up for 7 days
        let noOfDays:Int = 7
        
        //Add building data to the graph
        barGraphView.buildingValue = dataArray
        
        //Calculate average and total from graphPoints
        let total = dataArray.reduce(0, combine: +)
        println("The data has been retrieved.  The total value is: \(total)")
        
        //Indicate that the graph needs to be redrawn and labels updated on the main queue
//        dispatch_async(dispatch_get_main_queue()) {
//            // Round values to 100s places
//            self.maxLabel.text = "\(Int(maxElement(dataArray)))"
//            self.averageEnergyProducedValue.text = "\(round(100 * average) / 100)"
//            self.totalEnergyProducedValue.text = "\(round(100 * total) / 100)"
//            
//            // Set text labels visible
//            self.averageEnergyProducedLabel.hidden = false
//            self.totalEnergyProducedLabel.hidden = false
//            
//            self.graphView.setNeedsDisplay()
        }

}
