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
    @IBOutlet weak var building1Label: UILabel!
    @IBOutlet weak var building2Label: UILabel!
    @IBOutlet weak var energyUnitsLabel: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    
    // An array of raw building data
    var buildingsDictionaries = []
    
    var selectedBuildings = [String]()
    let energyTypeArray = ["Electricity", "Water", "Heating", "Total Energy"]
    let timePeriodArray = ["today", "this month", "this year"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fill in the building data array from the information in the plist
        if let path = NSBundle.mainBundle().pathForResource("buildings", ofType: "plist") {
            self.buildingsDictionaries = NSArray(contentsOfFile: path)!
        }
        // The default is total energy
        getGraphData("total energy")
    }
    
    // Loops through the list of selected buildings and creates the data request for each building
    func getGraphData(type:String){
        
        let startDate = getStartDate()
        let endDate = NSDate()
        let resolution = "month"
        
        // Array of all of the meters to get data from
        var searchName:[String] = []
        
        // Loops through all of the selected buildings and finds the correct meters
        for building in selectedBuildings {
            var energyIndex:Int
            switch type {
            case "electricity":
                energyIndex = 0
            case "water":
                energyIndex = 1
            case "heating":
                energyIndex = 2
            case "total energy":
                // 1 kWh = 3412.14163 btu
                // Need to send multiple requests.  Figure out how to do this
                energyIndex = 0
            default:
                energyIndex = 0
            }
            
            // Now that we know what type of meter we're looking for, find the meters that correspond
            // to the selected buildings
            for dict in self.buildingsDictionaries {
                if dict["displayName"] as! String == building{
                    var buildingName = dict["meters"] as! NSArray
                    if buildingName.count > energyIndex {
                        searchName.append(buildingName[energyIndex]["systemName"] as! String)
                    } else {
                        setupGraphDisplay([:])
                        return
                    }
                }
            }
        }
        let data : DataRetreiver = DataRetreiver()
        data.fetch(searchName, startDate: startDate, endDate: endDate, resolution: resolution, callback: setupGraphDisplay)
        
    }
    
    func setupGraphDisplay(results:[String:[Double]]) {
    
        //Change the name key from the meter name to the display name
        
        //MUST FIX THIS BECAUSE IT IS NOT CURRENTLY KEEPING THE ORDER OF THE ARRAY
        //An idea: do a for loop on the items in selectedBuildings; convert the name of current item (refer to this as "current") to the corresponding http request name (e.g. carleton_burton_...), and
        //set dataArrayWithDisplayNames["current"] = results[http request name], since might not be in order
        var dataArrayWithDisplayNames = [String:[Double]]()
        var count = 0
        for (key, value) in results{
            //self.selectedBuildings[count] retrieves the key corresponding to building
            dataArrayWithDisplayNames[self.selectedBuildings[count]] = value
            count++
        }
        
        //Add building data to the graph
        self.barGraphView.loadData(dataArrayWithDisplayNames)
        
        //Calculate average and total from graphPoints
//        let total = dataArray[selectedBuildings[0].reduce(0, combine: +)
//        println("The data has been retrieved.  The total value is: \(total)")
        
        //Indicate that the graph needs to be redrawn and labels updated on the main queue
        dispatch_async(dispatch_get_main_queue()) {
            self.building1Label.text = self.selectedBuildings[0]
            self.building2Label.text = self.selectedBuildings[self.selectedBuildings.count-1]
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
        getGraphData(self.energyTypeLabel.text!.lowercaseString)
        switch self.energyTypeLabel.text!.lowercaseString {
        case "electricity":
            self.energyUnitsLabel.text = "total kWh"
        case "water":
            self.energyUnitsLabel.text = "total gal"
        case "heating":
            self.energyUnitsLabel.text = "total kBTU"
        case "total energy":
            self.energyUnitsLabel.text = "total kBTU"
        default:
            self.energyUnitsLabel.text = "total kWh"
        }
    }
    

}
