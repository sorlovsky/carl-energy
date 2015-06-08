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
    @IBOutlet weak var maxSpeedLabel: UILabel!
    var resolution: String?
    
    var desiredData = [String]()
    
    // This function gets called whenever the view appears from a segue from the ProductionViewController
    override func viewWillAppear(animated: Bool) {
        
        /*  A note about building names:
            When asking the database for information about a specific building, the formatting is very precise.  For
            example, asking for Burton's steam data looks like this:
            https://rest.buildingos.com/reports/timeseries/?start=2015/05/09+19:22:32&end=2015/05/10+19:22:32&resolution=hour&name=carleton_burton_steam_use
            The options that we can ask for are "steam", "water", and "en" short for energy.  Therefore for every building
            the format is "carleton_\(buildingName.lowercaseString)_\(dataType)_use".  There are a couple noteworthy
            exceptions:
                a) Cassat and James have their own electricity meters but not steam and water.  Therefore asking for "carleton_cassat_steam_use" is invalid.
                b) Cassat and James have combined systems.  The format is: "carleton_cassatjames_en_use".
                c) The Main Campus has 7 meters.  Steam and energy are the same as any building.
                    i)      Gas use is accessed with the format:    "carleton_campus_gas_use"
                    ii)     Solar production is accessed with:      "carleton_campus_total_pv_production"
                    iii)    Turbine 1 is accessed with:             "carleton_turbine1_produced_power"
                    iv)     Turbine 2 is accessed with:             "carleton_wind_production"
                    v)      Wind speed data is accessed with:       "carleton_wind_speed
        
            The way that the previous version of this app dealt with this was by having a buildings.plist file that was
            referred to whenever a building's meter name was asked for.  We should look into this.
        */

        // For now let's just focus on electricity
        for dataIndex in 0..<desiredData.count-1{
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
        let resolution: String = desiredData[desiredData.count-1]
        print("resolution: ")
        println(resolution)
        
        desiredData.removeAtIndex(desiredData.count-1)
        print("desiredData: ")
        println(desiredData)
        data.fetch(desiredData, startDate: startDate, endDate: endDate, resolution: resolution, callback: setupGraphDisplay)
        // Fetches the data.  When the data is retreived it calls setupGraphDisplay()
//        data.fetch(searchName, startDate: startDate, endDate: endDate, resolution: "day", callback: setupGraphDisplay)

    }


    func setupGraphDisplay(results:[String:[Double]]) {
        let dataArray = results
        
        //Use 7 days for graph - can use any number,
        //but labels and sample data are set up for 7 days
        //if we're doing days, then we would set a variable equal to 7, and use that one.
        let noOfDays:Int = 7
        graphView.resolutionNumber = noOfDays
        
        graphView.drawGraphPoints(dataArray)
        
    //can add more cases regarding production data values later
        var productionPoints = [Double]()
        productionPoints = graphView.turbineData["carleton_wind_production"]!
        let maxSpeedVal = graphView.turbineData["carleton_wind_speed"]!
        let total = productionPoints.reduce(0, combine: +)
        let average = total / Double(productionPoints.count)
        
        //Indicate that the graph needs to be redrawn and labels updated on the main queue
        dispatch_async(dispatch_get_main_queue()) {
            // Round values to 100s places
            self.maxLabel.text = "\(Int(maxElement(productionPoints)))"
            self.maxSpeedLabel.text = "\(Int(maxElement(maxSpeedVal)))"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
