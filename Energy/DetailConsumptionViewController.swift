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
    @IBOutlet weak var energyTypeLabel: UILabel!
    @IBOutlet weak var building1Label: UILabel!
    @IBOutlet weak var energyUnitsLabel: UILabel!
    
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
        
        let data : DataRetreiver = DataRetreiver()
        
        var energyType:String
        switch type {
        case "electricity":
            energyType = "_en_use"
        case "water":
            energyType = "_water_use"
        case "heating":
            energyType = "_steam_use"
        case "total energy":
            // 1 kWh = 3412.14163 btu
            // Need to send multiple requests.  Figure out how to do this
            energyType = "_en_use"
        default:
            energyType = "_en_use"
        }
        
        for building in selectedBuildings {
            
            var searchName = "carleton_\(selectedBuildings[0].lowercaseString)"
            // For now we can only do one building
            searchName = searchName.componentsSeparatedByString(" ")[0]
            searchName = searchName + energyType
            data.fetch(searchName, startDate: startDate, endDate: endDate, resolution: "day", callback: setupGraphDisplay)
        }
    }
    
    func setupGraphDisplay(results:NSArray) {
        let dataArray = results as! [Double]
        
        //Add building data to the graph
        self.barGraphView.loadData(selectedBuildings[0], data: dataArray)
        
        //Calculate average and total from graphPoints
        let total = dataArray.reduce(0, combine: +)
        println("The data has been retrieved.  The total value is: \(total)")
        
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
