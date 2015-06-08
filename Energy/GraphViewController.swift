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

import UIKit

class GraphViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    
    var TURBINE1: String = "carleton_turbine1_produced_power"
    let TURBINE2: String = "carleton_wind_production"
    let TURBINE2SPEED: String = "carleton_wind_speed"
    let SOLARPV: String = "carleton_campus_total_pv_prod"
    
    let LAST4WKS: String = "last4weeks"
    let LASTWK: String = "lastweek"
    let LASTYR: String = "lastyear"
    let TODAY: String = "today"
    
    let NUM_TODAY: Int = 24
    let NUM_4WKS: Int = 28
    let NUM_LASTYR: Int = 12
    let NUM_LASTWK: Int = 7
    
    var period: String?
    
//    var desiredData = [String]()
    
    // This function gets called whenever the view appears from a segue from the ProductionViewController
    override func viewWillAppear(animated: Bool) {
        println("secondhello")

        // For now let's just focus on electricity
        let data: DataRetreiver = DataRetreiver()
        period = LASTWK
//        data.fetchOverTimePeriod("carleton_wind_production", timePeriod: LAST4WKS, callback: setupGraphDisplay)
        data.fetchOverTimePeriod("carleton_wind_production", timePeriod: LASTWK, callback: setupGraphDisplay)
        
        
//        // Sample date data
//        let dateComponents = NSDateComponents()
//        dateComponents.year = 2015
//        dateComponents.month = 05
//        dateComponents.day = 11
//        let startDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
//        dateComponents.day = 17
//        let endDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!


    }


    func setupGraphDisplay(results:[String:[Double]]) {
        let dataArray = results
        let nameOfProducer = (results.keys.array)[0]
        println(nameOfProducer)
        switch(period!){
            case LAST4WKS:
                graphView.maximumNumberOfItems = NUM_4WKS
            case LASTWK:
                graphView.maximumNumberOfItems = NUM_LASTWK
            case LASTYR:
                graphView.maximumNumberOfItems = NUM_LASTYR
            case TODAY:
                graphView.maximumNumberOfItems = NUM_TODAY
            default:
                graphView.maximumNumberOfItems = NUM_LASTWK
        }
        switch(nameOfProducer){
            case TURBINE1:
                graphView.TURBINE1PRODUCTION = dataArray[nameOfProducer]!
            case TURBINE2:
                graphView.TURBINE2PRODUCTION = dataArray[nameOfProducer]!
            case TURBINE2SPEED:
                graphView.TURBINE2SPEED = dataArray[nameOfProducer]!
            case SOLARPV:
                graphView.SOLARPV = dataArray[nameOfProducer]!
            default:
                println("error in format of results")
        }
        
        graphView.drawGraphPoints()
        
        
    //can add more cases regarding production data values later
//        var productionPoints = [Double]()
//        productionPoints = graphView.turbineData["carleton_wind_production"]!
//        let maxSpeedVal = graphView.turbineData["carleton_wind_speed"]!
//        let total = productionPoints.reduce(0, combine: +)
//        let average = total / Double(productionPoints.count)
//        
//        //Indicate that the graph needs to be redrawn and labels updated on the main queue
//        dispatch_async(dispatch_get_main_queue()) {
//            // Round values to 100s places
//            self.maxLabel.text = "\(Int(maxElement(productionPoints)))"
//            self.maxSpeedLabel.text = "\(Int(maxElement(maxSpeedVal)))"
//            self.averageEnergyProducedValue.text = "\(round(100 * average) / 100)"
//            self.totalEnergyProducedValue.text = "\(round(100 * total) / 100)"
//            
//            // Set text labels visible
//            self.averageEnergyProducedLabel.hidden = false
//            self.totalEnergyProducedLabel.hidden = false
//            
//            self.graphView.setNeedsDisplay()
//        }
//        
//        
//        //Set up labels
//        //Day of week labels are set up in storyboard with tags
//        //Today is last day of the array need to go backwards
//
//        //Get today's day number
//        let componentOptions:NSCalendarUnit = .CalendarUnitWeekday
//        let components = calendar.components(componentOptions,
//            fromDate: NSDate())
//        var weekday = components.weekday
//        
//        //Set up the day name labels with correct day
//        let days = ["S", "S", "M", "T", "W", "T", "F"]
//        for i in reverse(1...days.count) {
//            if let labelView = graphView.viewWithTag(i) as? UILabel {
//                if weekday == 7 {
//                    weekday = 0
//                }
//                dispatch_sync(dispatch_get_main_queue()) {
//                    if weekday < 0 {
//                        weekday = days.count - 1
//                    }
//                    labelView.text = days[weekday]
//                    weekday = weekday-1
//                }
//            }
//        }
    }
    
    @IBAction func showWindSpeedSwitch(sender: AnyObject) {
        
    }


}
