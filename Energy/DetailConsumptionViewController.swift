//
//  DetailConsumptionViewController.swift
//  Energy
//
//  Created by Simon Orlovsky on 5/10/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

class DetailConsumptionViewController: UIViewController {
    
    @IBOutlet weak var barGraphView: BarGraphView!
    @IBOutlet weak var energyTypeLabel: UILabel!
    @IBOutlet weak var building1Label: UILabel!
    @IBOutlet weak var energyUnitsLabel: UILabel!
    
    var selectedBuildings = [String]()
    let energyTypeArray = ["Electricity", "Water", "Heating", "Total Energy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGraphData("electricity")
    }
    
    func getGraphData(type:String){
        // Sample date data
        let dateComponents = NSDateComponents()
        dateComponents.year = 2015
        dateComponents.month = 05
        dateComponents.day = 11
        let startDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        dateComponents.day = 17
        let endDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        
        var buildingsDictionaries = []
        if let path = NSBundle.mainBundle().pathForResource("buildings", ofType: "plist") {
            buildingsDictionaries = NSArray(contentsOfFile: path)!
        }
        
        for building in selectedBuildings {
            
            let data : DataRetreiver = DataRetreiver()
            
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
            
            var searchName = ""
            
            for dict in buildingsDictionaries {
                if dict["displayName"] as! String == building{
                    var buildingName = dict["meters"] as! NSArray
                    if buildingName.count > energyIndex {
                        searchName = buildingName[energyIndex]["systemName"] as! String
                    } else {
                        setupGraphDisplay([])
                    }
                }
            }
            
            data.fetch(searchName, startDate: startDate, endDate: endDate, resolution: "day", callback: setupGraphDisplay)
        }
    }
    
    func setupGraphDisplay(results:NSArray) {
        let dataArray = results as! [Double]
        
        //Add building data to the graph
        self.barGraphView.loadData(selectedBuildings[0], data: dataArray)
        
        //Calculate average and total from graphPoints
        let total = dataArray.reduce(0, combine: +)
        // println("The data has been retrieved.  The total value is: \(total)")
        
        //Indicate that the graph needs to be redrawn and labels updated on the main queue
        dispatch_async(dispatch_get_main_queue()) {
            self.building1Label.text = self.selectedBuildings[0]
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
            if currentEnergyTypeIndex == 3 {
                currentEnergyTypeIndex = -1
            }
            self.energyTypeLabel.text = self.energyTypeArray[currentEnergyTypeIndex+1]
            updateGraphEnergyData()
        }
    }
    
    func updateGraphEnergyData(){
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
