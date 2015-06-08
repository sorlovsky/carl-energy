//
//  ConsumptionViewController.swift
//  ios_project
//
//  Created by Simon Orlovsky on 4/18/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

class ConsumptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //Segmented control
    @IBOutlet var segmentedControl: UISegmentedControl!
    //Search bar
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBarObj: UISearchBar!
    
    // Title bar item
    @IBOutlet var barTitleItem: UINavigationItem!
    
    //Menu bar button that triggers SWRevealViewController
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var selectedBuilding = Building(name: "default", imageName: "default", isSelected: false)
//    var selectedBuildingIndex:Int? = nil

    //Building Data
//    var buildingArray = [String]()
//    var buildingImageNames = [String]()
    var buildings = [Building]()
    var searchBuildings = [Building]()
    

    var isSearching:Bool!
//    var searchingDataArray = [String]()
//    var searchingDataArrayImages = [String]()
    var selectedBuildings = [Building]()
    
    @IBOutlet var modeBarButton: UIBarButtonItem!
    var comparisonMode = false
    
    @IBOutlet var createReportButton: UIButton!
    
    
    override func viewDidLoad() {
        //Get the buildings from buildings.plist and add them to the buildingArray
        var buildingsDictionaries = []
        if let path = NSBundle.mainBundle().pathForResource("buildings", ofType: "plist") {
            buildingsDictionaries = NSArray(contentsOfFile: path)!
        }
        for dict in buildingsDictionaries {
            var buildingName = dict["displayName"] as! String
            var buildingImage = dict["image"] as! String
            buildings.append(Building(name: buildingName, imageName: buildingImage, isSelected: false))
        }
        
        //Setting initial mode
        createReportButton.hidden = true
        modeBarButton.title = "Compare"
        
        //Search
        isSearching = false
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //SWRevealViewController
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isSearching == true{
            return searchBuildings.count
        }else{
            return buildings.count  //Currently Giving default Value
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        
        if isSearching == true{
            if searchBuildings[indexPath.row].isSelected == true{
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else{
                cell.accessoryType == .None
            }
            
            cell.textLabel!.text = searchBuildings[indexPath.row].name
            cell.imageView!.image = UIImage(named:searchBuildings[indexPath.row].imageName)
            
        }else{
            if buildings[indexPath.row].isSelected == true{
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else{
                cell.accessoryType = .None
            }

            cell.textLabel!.text = buildings[indexPath.row].name
            cell.imageView!.image = UIImage(named:buildings[indexPath.row].imageName)

            
            
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        
        if (comparisonMode == true) {
            if(isSearching == false){
                for var i=0; i<buildings.count; i++ {
                    if buildings[i].name == (cell!.textLabel?.text)!{
                        if buildings[i].isSelected == false{
                            buildings[i].isSelected = true
                            selectedBuildings.append(buildings[i])
                            tableView.reloadData()
                        }
                        else{
                            buildings[i].isSelected = false
                            for var j=0; j<selectedBuildings.count; j++ {
                                if selectedBuildings[j].name == buildings[i].name{
                                    selectedBuildings.removeAtIndex(j)
                                }
                            }
                            tableView.reloadData()
                        }
                    }
                }

            }
            if(isSearching == true){
                for var i=0; i<searchBuildings.count; i++ {
                    if searchBuildings[i].name == (cell!.textLabel?.text)!{
                        if searchBuildings[i].isSelected == false{
                            searchBuildings[i].isSelected = true
                            selectedBuildings.append(searchBuildings[i])
                            tableView.reloadData()
                        }
                        else{
                            searchBuildings[i].isSelected = false
                            for var j=0; j<selectedBuildings.count; j++ {
                                if selectedBuildings[j].name == searchBuildings[i].name{
                                    selectedBuildings.removeAtIndex(j)
                                }
                            }
                            tableView.reloadData()
                        }
                    }
                }

            }
        } else {
            if (isSearching == true){
                selectedBuildings.append(searchBuildings[indexPath.row])
            }
            else{
                selectedBuildings.append(buildings[indexPath.row])
            }
        }
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
//        if let index = selectedBuildingIndex {
//            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
////            cell?.accessoryType = .None
//        }
//        
//        selectedBuildingIndex = indexPath.row
//        selectedBuilding = buildings[indexPath.row]
        
        if (comparisonMode == false){
            performSegueWithIdentifier("Single", sender: tableView)
        }
        
        
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text.isEmpty{
            isSearching = false
            tableView.reloadData()
        } else {
//            println(" search text %@ ",searchBar.text as NSString)
            isSearching = true
//            searchingDataArray.removeAll()
//            searchingDataArrayImages.removeAll()
            searchBuildings.removeAll()
            for var index = 0; index < buildings.count; index++
            {
                var currentString = buildings[index].name
                
//                if currentString.lowercaseString == searchText.lowercaseString{
//                    searchingDataArray.append(currentString);
//                }
                if currentString.lowercaseString.hasPrefix(searchText.lowercaseString) == true {
                    for var i = 0; i < buildings.count; i++ {
                        if (buildings[i].name == currentString){
                            searchBuildings.append(buildings[i])
                        }
                    }
//                    searchBuildings.append(currentString)
//                    searchingDataArrayImages.append(buildingImageNames[index])
                    
                }
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func modeButtonClicked(sender: AnyObject) {
        if (comparisonMode==false){
            comparisonMode = true
            createReportButton.hidden = false;
            modeBarButton.title = "Single"
            barTitleItem.title = "Choose Buildings"
            
        }
        else{
            comparisonMode = false
            createReportButton.hidden = true;
            modeBarButton.title = "Compare"
            barTitleItem.title = "Choose Building"
            
        }
        selectedBuildings.removeAll()
//        selectedBuildingIndex = nil;
        self.tableView.reloadData()

    }
  
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    @IBOutlet var testLabel: UILabel!
    
    
    //Function so that when user selects academic buildings on seg control only academic buildings appear
    //Will be implemented in the future
    @IBAction func segmentedControlAction(sender: AnyObject) {
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            testLabel.text = "A";
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {
            testLabel.text = "Ac";
        }
        else if(segmentedControl.selectedSegmentIndex == 2)
        {
            testLabel.text = "D";
        }
    }
    
    
    @IBAction func reportButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("Detail", sender: tableView)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Detail" {
            println("Selected Buildings:"+selectedBuildings[0])
            if let destinationVC = segue.destinationViewController as? DetailConsumptionViewController{
                // Transferring all selected buildings to the DetailComsumptionViewController so that it can 
                // produce a report comparing buildings.
                for var index = 0; index < selectedBuildings.count; index++
                {
                    destinationVC.selectedBuildings.append(self.selectedBuildings[index].name)
                }
            }
        }
        if segue.identifier == "Single" {
            if let destinationVC = segue.destinationViewController as? ColumnGraphViewController {
                if let tappedCellIndex = sender?.indexPathForSelectedRow()?.row {
                    destinationVC.selectedBuilding = buildingArray[tappedCellIndex]
                }
            }
        }
    }
    
}



