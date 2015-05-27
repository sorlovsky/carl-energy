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
    
    //Menu bar button that triggers SWRevealViewController
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var selectedBuilding:String? = nil
    var selectedBuildingIndex:Int? = nil

    //Building Data
    var buildingArray = [String]()
    var buildingImageNames = [String]()

    var isSearching:Bool!
    var searchingDataArray = [String]()
    var selectedBuildings = [String]()
    
    override func viewDidLoad() {
        
        //Get the buildings from buildings.plist and add them to the buildingArray
        var buildingsDictionaries = []
        if let path = NSBundle.mainBundle().pathForResource("buildings", ofType: "plist") {
            buildingsDictionaries = NSArray(contentsOfFile: path)!
        }
        for dict in buildingsDictionaries {
            var buildingName = dict["displayName"] as! String
            var buildingImage = dict["image"] as! String
            self.buildingArray.append(buildingName)
            self.buildingImageNames.append(buildingImage)
        }
        
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
            return searchingDataArray.count
        }else{
            return buildingArray.count  //Currently Giving default Value
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        if isSearching == true{
            cell.textLabel!.text = searchingDataArray[indexPath.row]
        }else{
            cell.textLabel!.text = buildingArray[indexPath.row]
            cell.imageView!.image = UIImage(named:buildingImageNames[indexPath.row])
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
            println(" cell Selected #\(indexPath.row)! \(buildingArray[indexPath.row])")
        }
        else{
            println(" cell Selected #\(indexPath.row)! \(searchingDataArray[indexPath.row])")
        }
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell!.accessoryType == .Checkmark{
            cell?.accessoryType = .None
            var index = find(selectedBuildings, buildingArray[indexPath.row])
            selectedBuildings.removeAtIndex(index!)
        }
        else{
            cell!.accessoryType = .Checkmark
            selectedBuildings.append(buildingArray[indexPath.row])
            NSLog("Object added")
        }
        

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedBuildingIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
//            cell?.accessoryType = .None
        }
        
        selectedBuildingIndex = indexPath.row
        selectedBuilding = buildingArray[indexPath.row]
        
        
        
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
            searchingDataArray.removeAll()
            for var index = 0; index < buildingArray.count; index++
            {
                var currentString = buildingArray[index]
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchingDataArray.append(currentString)
                    
                }
            }
            tableView.reloadData()
        }
    }
    
    @IBOutlet var testLabel: UILabel!
    
    
    //Function so that when user selects academic buildings on seg control only academic buildings appear
    @IBAction func segmentedControlAction(sender: AnyObject) {
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            testLabel.text = "All";
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {
            testLabel.text = "Academic";
        }
        else if(segmentedControl.selectedSegmentIndex == 2)
        {
            testLabel.text = "Dorms";
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
                // Transferring all selected buildings to the DetailComsumptionViewController so that it can 
                // produce a report comparing buildings.
                for var index = 0; index < selectedBuildings.count; index++
                {
                    destinationVC.selectedBuildings.append(self.selectedBuildings[index])
                }
            }
            
        }
    }
    
}



