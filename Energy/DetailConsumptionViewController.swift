//
//  DetailConsumptionViewController.swift
//  Energy
//
//  Created by Simon Orlovsky on 5/10/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

class DetailConsumptionViewController: UIViewController {
    
    // Label outlets
    @IBOutlet weak var barGraphView: BarGraphView!
    @IBOutlet weak var energyTypeLabel: UILabel!
    @IBOutlet weak var energyUnitsLabel: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    
    // An array of raw building data
    var buildingsDictionaries = []
    
    var selectedBuildings = [String]()
    let energyTypeArray = ["Electricity", "Water", "Natural Gas", "Steam Condensate", "Total Energy"]
    let timePeriodArray = ["today", "month", "year"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // The default is total energy
        getGraphData("total energy", resolution: "month")
    }
    
    // Loops through the list of selected buildings and creates the data request for each building
    func getGraphData(type:String, resolution:String) {
        
        let startDate = getStartDate()
        let endDate = NSDate()
        let data : DataRetreiver = DataRetreiver()
        var meterType = type
        
        // fix this later
        if type.lowercaseString == "total energy" {
            meterType = "Electricity"
        }
        
        data.fetch(self.selectedBuildings, meterType: meterType, startDate: startDate, endDate: endDate, resolution: resolution, callback: setupGraphDisplay)
    }
    
    func setupGraphDisplay(results:[String:[Double]]) {
    
        //Add building data to the graph
        self.barGraphView.loadData(results)
        
        //Indicate that the graph needs to be redrawn and labels updated on the main queue
        dispatch_async(dispatch_get_main_queue()) {
            self.barGraphView.setNeedsDisplay()
        }
    }
    
    @IBAction func energyTypeBackButtonPressed(sender: AnyObject) {
        if var currentEnergyTypeIndex = find(self.energyTypeArray, self.energyTypeLabel.text!) {
            if currentEnergyTypeIndex == 0 {
                currentEnergyTypeIndex = energyTypeArray.count
            }
            self.energyTypeLabel.text = self.energyTypeArray[currentEnergyTypeIndex-1]
            updateGraphEnergyData()
        }
    }
    
    @IBAction func energyTypeForwardButtonPressed(sender: AnyObject) {
        if var currentEnergyTypeIndex = find(self.energyTypeArray, self.energyTypeLabel.text!) {
            if currentEnergyTypeIndex == energyTypeArray.count-1 {
                currentEnergyTypeIndex = -1
            }
            self.energyTypeLabel.text = self.energyTypeArray[currentEnergyTypeIndex+1]
            updateGraphEnergyData()
        }
    }
    
    func getStartDate() -> NSDate {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let dateComponents = NSDateComponents()

        switch self.timePeriodLabel.text! {
        case "today":
            println("today!")
        case "this month":
            dateComponents.day = 01
        case "this year":
            dateComponents.year = components.year
            dateComponents.month = 01
            dateComponents.day = 01
        default:
            dateComponents.day = 01
        }
        let startDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        return startDate
    }
    
    func updateGraphEnergyData() {
        getGraphData(self.energyTypeLabel.text!, resolution: "month")
        switch self.energyTypeLabel.text! {
        case "Electricity":
            self.energyUnitsLabel.text = "total kWh"
        case "Water":
            self.energyUnitsLabel.text = "total gal"
        case "Steam Condensate":
            self.energyUnitsLabel.text = "total kBTU"
        case "Total Energy":
            self.energyUnitsLabel.text = "total kBTU"
        default:
            self.energyUnitsLabel.text = "total kWh"
        }
    }
    

}
