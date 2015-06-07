//
//  GraphViewController.swift
//  Energy
//
//  Created by Caleb Braun on 5/18/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//
//  This is a template for how our graph views will look.  The GraphViewController contains a Graph View inside of
//  Container View inside of a View.  This layering is done so that we will be able to add more elements in the most
//  helpful places.  These elements will include various ways the user can view the data (time period), which buildings
//  they want to see, and which type of energy use they want to select (electricity, steam, water, total BTU).
//
//  Most of the graph display is based off of the tutorial found here: http://www.raywenderlich.com/90693/modern-core-graphics-with-swift-part-2
//

import UIKit

class GraphViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    
    //Label outlets
    @IBOutlet weak var averageEnergyProducedValue: UILabel!
    @IBOutlet weak var totalEnergyProducedValue: UILabel!
    @IBOutlet weak var averageEnergyProducedLabel: UILabel!
    @IBOutlet weak var totalEnergyProducedLabel: UILabel!
    
    @IBOutlet weak var maxLabel: UILabel!
    
    var desiredData = [String]()
    
    // This function gets called whenever the view appears from a segue from the ProductionViewController
    override func viewWillAppear(animated: Bool) {
        

        // For now let's just focus on electricity
        for dataIndex in 0..<desiredData.count{
            desiredData[dataIndex] = "carleton_\(desiredData[dataIndex].lowercaseString)"
        }
        println(desiredData)
        // Sample date data
        let dateComponents = NSDateComponents()
        dateComponents.year = 2015
        dateComponents.month = 05
        dateComponents.day = 11
        let startDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        dateComponents.day = 17
        let endDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        
        let data : DataRetreiver = DataRetreiver()
        // data.fetch(desiredData, startDate: startDate, endDate: endDate, resolution: "day", callback: setupGraphDisplay)
        // Fetches the data.  When the data is retreived it calls setupGraphDisplay()
//        data.fetch(searchName, startDate: startDate, endDate: endDate, resolution: "day", callback: setupGraphDisplay)

    }


    func setupGraphDisplay(results:[String:[Double]]) {
        let dataArray = results
        
        //Use 7 days for graph - can use any number,
        //but labels and sample data are set up for 7 days
        let noOfDays:Int = 7
        
        graphView.drawGraphPoints(dataArray)
        
        //Add building data to the graph
        // graphView.drawGraphPoints(dataArray)
        
//        println("The data has been retrieved.  The values are: \(graphView.graphPoints)")
        
        //Calculate average and total from graphPoints
//        var statisticsArray = [[Double]]()
//        for i in 0..<dataArray.count{
//            var statistics = [Double]()
//            let total = [String](graphView.graphPoints.keys)[i].reduce(0, combine: +)
//            let average = total / Double(graphView.graphPoints[i].count)
//            statistics.append(total)
//            statistics.apppend(average)
//            statisticsArray.append(statistics)
        
    //can add more cases regarding production data values later
        var productionPoints = [Double]()
        productionPoints = graphView.turbineData["carleton_wind_production"]!
        let total = productionPoints.reduce(0, combine: +)
        let average = total / Double(productionPoints.count)
        
        //Indicate that the graph needs to be redrawn and labels updated on the main queue
        dispatch_async(dispatch_get_main_queue()) {
            // Round values to 100s places
            self.maxLabel.text = "\(Int(maxElement(productionPoints)))"
            self.averageEnergyProducedValue.text = "\(round(100 * average) / 100)"
            self.totalEnergyProducedValue.text = "\(round(100 * total) / 100)"
            
            // Set text labels visible
            self.averageEnergyProducedLabel.hidden = false
            self.totalEnergyProducedLabel.hidden = false
            
            self.graphView.setNeedsDisplay()
        }
        
        
        //Set up labels
        //Day of week labels are set up in storyboard with tags
        //Today is last day of the array need to go backwards
        
        //Get today's day number
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .CalendarUnitWeekday
        let components = calendar.components(componentOptions,
            fromDate: NSDate())
        var weekday = components.weekday
        
        //Set up the day name labels with correct day
        let days = ["S", "S", "M", "T", "W", "T", "F"]
        for i in reverse(1...days.count) {
            if let labelView = graphView.viewWithTag(i) as? UILabel {
                if weekday == 7 {
                    weekday = 0
                }
                dispatch_sync(dispatch_get_main_queue()) {
                    if weekday < 0 {
                        weekday = days.count - 1
                    }
                    labelView.text = days[weekday]
                    weekday = weekday-1
                }
            }
        }
    }
    
    @IBAction func showWindSpeedSwitch(sender: AnyObject) {
        
    }


}
