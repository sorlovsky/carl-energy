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
    
    @IBOutlet weak var barGraphView: BarGraphView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sample date data
        let dateComponents = NSDateComponents()
        dateComponents.year = 2015
        dateComponents.month = 05
        dateComponents.day = 11
        let startDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        dateComponents.day = 17
        let endDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        
        let data : DataRetreiver = DataRetreiver()
        
        
        // For now let's just focus on electricity
        for building in selectedBuildings {
                 
            var searchName = "carleton_\(selectedBuildings[0].lowercaseString)"
            // FOr now we can only do one building
            searchName = searchName.componentsSeparatedByString(" ")[0]
            searchName = searchName + "_en_use"
            data.fetch(searchName, startDate: startDate, endDate: endDate, resolution: "day", callback: setupGraphDisplay)
        }
    }
    
    
    
    func setupGraphDisplay(results:NSArray) {
        let dataArray = results as! [Double]
        
        //Use 7 days for graph - can use any number,
        //but labels and sample data are set up for 7 days
        let noOfDays:Int = 7
        
        //Add building data to the graph
        self.barGraphView.loadData(selectedBuildings[0], data: dataArray)
        
        //Calculate average and total from graphPoints
        let total = dataArray.reduce(0, combine: +)
        println("The data has been retrieved.  The total value is: \(total)")
        
        //Indicate that the graph needs to be redrawn and labels updated on the main queue
        dispatch_async(dispatch_get_main_queue()) {
            self.barGraphView.setNeedsDisplay()
        }
    }

}
