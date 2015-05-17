//
//  ConsumptionViewController.swift
//  ios_project
//
//  Created by Simon Orlovsky on 4/18/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit



class ConsumptionViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBarObj: UISearchBar!
    
    
    var selectedBuilding:String? = nil
    var selectedBuildingIndex:Int? = nil
    
    var isSearching:Bool!
    
    var buildingArray:NSMutableArray!
    var searchingDataArray:NSMutableArray!
    var selectedBuildings = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isSearching = false
        buildingArray = ["Burton", "Willis", "Nourse", "Cassat", "Meyers", "Library" , "Boliou"]
        searchingDataArray = []
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Sample date data
        let dateComponents = NSDateComponents()
        dateComponents.year = 2015
        dateComponents.month = 05
        dateComponents.day = 16
        let startDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        dateComponents.day = 17
        let endDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        
        // name, startdate, enddate, resolution
        let data : DataRetreiver = DataRetreiver()
        
        data.fetch("carleton_burton_en_use", startDate: startDate, endDate: endDate, resolution: "hour", callback: buildGraphExample)
        
    }
    
    // TEST FUNCTION
    func buildGraphExample(results:NSArray) {
        println(results)


    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isSearching == true{
            return searchingDataArray.count
        }else{
            return buildingArray.count  //Currently Giving default Value
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if isSearching == true{
            cell.textLabel!.text = searchingDataArray[indexPath.row] as NSString as String
        }else{
            cell.textLabel!.text = buildingArray[indexPath.row] as? String
        }
        
        if indexPath.row == selectedBuildingIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isSearching == false{
            println(" cell Selected #\(indexPath.row)! \(buildingArray[indexPath.row] as NSString)")
        }
        else{
            println(" cell Selected #\(indexPath.row)! \(searchingDataArray[indexPath.row] as NSString)")
        }
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell!.accessoryType == .Checkmark{
            cell?.accessoryType = .None
            var index = find(selectedBuildings, buildingArray[indexPath.row] as String)
            selectedBuildings.removeAtIndex(index!)
        }
        else{
            cell!.accessoryType = .Checkmark
            selectedBuildings.append(buildingArray[indexPath.row] as String)
            NSLog("Object added")
        }
        

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedBuildingIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
//            cell?.accessoryType = .None
        }
        
        selectedBuildingIndex = indexPath.row
        selectedBuilding = buildingArray[indexPath.row] as? String
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text.isEmpty{
            isSearching = false
            tableView.reloadData()
        } else {
//            println(" search text %@ ",searchBar.text as NSString)
            isSearching = true
            searchingDataArray.removeAllObjects()
            for var index = 0; index < buildingArray.count; index++
            {
                var currentString = buildingArray.objectAtIndex(index)as String
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchingDataArray.addObject(currentString)
                    
                }
            }
            tableView.reloadData()
        }
    }
    @IBAction func reportButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("Detail", sender: tableView)
//        NSLog(selectedBuildings[0] as! String)

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Detail"
        {
            if let destinationVC = segue.destinationViewController as? DetailConsumptionViewController{
                for var index = 0; index < selectedBuildings.count; index++
                {
                    destinationVC.selectedBuildings.append(self.selectedBuildings[index])
                }
            }
            
        }
    }
    
}



