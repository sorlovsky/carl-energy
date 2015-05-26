//
//  ConsumptionViewController.swift
//  ios_project
//
//  Created by Simon Orlovsky on 4/18/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit



class ConsumptionViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //Search bar
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBarObj: UISearchBar!
    
    //Menu bar button that triggers SWRevealViewController
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var selectedBuilding:String? = nil
    var selectedBuildingIndex:Int? = nil
    
    var isSearching:Bool!
    
    var buildingArray = [String]()
    var searchingDataArray:NSMutableArray!
    var selectedBuildings = [String]()
    
    override func viewDidLoad() {
        
        //Get the buildings from buildings.plist and add them to the buildingArray
        var buildingsDictionaries = []
        if let path = NSBundle.mainBundle().pathForResource("buildings", ofType: "plist") {
            buildingsDictionaries = NSArray(contentsOfFile: path)!
        }
        for dict in buildingsDictionaries {
            var buildingName = dict["displayName"] as! String
            self.buildingArray.append(buildingName)
        }
        
        //Search
        isSearching = false
        searchingDataArray = []
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
            cell.textLabel!.text = searchingDataArray[indexPath.row] as! NSString as String
        }else{
            cell.textLabel!.text = buildingArray[indexPath.row]
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
            println(" cell Selected #\(indexPath.row)! \(searchingDataArray[indexPath.row] as! NSString)")
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
            searchingDataArray.removeAllObjects()
            for var index = 0; index < buildingArray.count; index++
            {
                var currentString = buildingArray[index]
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



