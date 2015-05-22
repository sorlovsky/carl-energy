//
//  DataRetreiver.swift
//  Energy
//
//  Created by Caleb Braun on 5/11/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//
//  This class represents a DataRetreiver object that connects to the BuildingOS API.  Given a building, time range,
//  and resolution (data every hour, day, etc.) it returns an array of the energy data.
//
//  With help from http://jamesonquave.com/blog/developing-ios-apps-using-swift-tutorial-part-2/
//

import UIKit

class DataRetreiver: NSObject {
    
    // This method returns an NSURL based on the requested start and end dates, building, and resolution.
    func URLFormatter(name : String, startDate: NSDate, endDate : NSDate, resolution : String) -> NSURL {
        
        // The NSDateFormatter() changes the date into the correct format for the URL
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd+HH:mm:ss"
        
        var startDateString = dateFormatter.stringFromDate(startDate)
        var endDateString = dateFormatter.stringFromDate(endDate)
        
        // Formats the URL correctly
        let urlString = "https://rest.buildingos.com/reports/timeseries/?start=\(startDateString)&end=\(endDateString)&resolution=\(resolution)&name=\(name)"
        
        return NSURL(string: urlString)!
    }
    
    
    
    // Fetches the data based on the URL created upon initialization
    func fetch(name : String, startDate: NSDate, endDate : NSDate, resolution : String, callback: (NSArray)->Void){
        
        var url : NSURL = URLFormatter(name, startDate: startDate, endDate: endDate, resolution: resolution)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if(error != nil){
                // Prints error to the console
                println(error.localizedDescription)
            }
            
            var jsonError: NSError?
            // Parses the JSON and casts it as an NSDictionary
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary
            
            if(jsonError != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(jsonError!.localizedDescription)")
                println(url)
            } else {
                // Only takes the results of the search and casts as an NSArray
                if let results: NSArray = jsonResult!["results"] as? NSArray{
                    callback(results)
                }
            }
        })
        
        // start the task
        task.resume()
    }
    
    
}
