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
    
    var is_searching:Bool!
    
    var dataArray:NSMutableArray!
    var searchingDataArray:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        is_searching = false
        dataArray = ["Burton", "Willis", "Nourse", "Cassat", "Meyers", "Library" , "Boliou"]
        searchingDataArray = []
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        
        
    }
    
    func parseJSONSwift(requestUrl: NSString) -> NSDictionary{
        var error: NSError?
        var dataGet:NSData! = NSData(contentsOfURL: NSURL(string: requestUrl as String)!)
        var dataDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataGet, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        return dataDictionary
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if is_searching == true{
            return searchingDataArray.count
        }else{
            return dataArray.count  //Currently Giving default Value
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        if is_searching == true{
            cell.textLabel!.text = searchingDataArray[indexPath.row] as! NSString as String
        }else{
            cell.textLabel!.text = dataArray[indexPath.row] as! String
        }
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(" cell Selected #\(indexPath.row)! %@ ",dataArray[indexPath.row] as! NSString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text.isEmpty{
            is_searching = false
            tableView.reloadData()
        } else {
//            println(" search text %@ ",searchBar.text as NSString)
            is_searching = true
            searchingDataArray.removeAllObjects()
            for var index = 0; index < dataArray.count; index++
            {
                var currentString = dataArray.objectAtIndex(index)as! String
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchingDataArray.addObject(currentString)
                    
                }
            }
            tableView.reloadData()
        }
    }
    
}



