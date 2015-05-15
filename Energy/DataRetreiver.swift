//
//  DataRetreiver.swift
//  Energy
//
//  Created by mobiledev on 5/11/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//
//  With help from http://jamesonquave.com/blog/developing-ios-apps-using-swift-tutorial-part-2/
//

import UIKit

class DataRetreiver: NSObject {
    
    var url : NSURL
    var data : NSArray = []
    
    init(name : String, startDate: NSDate, endDate : NSDate, resolution : String) {
        
        // This is to change the date into the correct format for the URL
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd+HH:mm:ss"
        
        var startDateString = dateFormatter.stringFromDate(startDate)
        var endDateString = dateFormatter.stringFromDate(endDate)
        
        // Formats the URL correctly
        let urlString = "https://rest.buildingos.com/reports/timeseries/?start=\(startDateString)&end=\(endDateString)&resolution=\(resolution)&name=\(name)"

        self.url = NSURL(string: urlString)!

        super.init()
        
    }
    
    
    // Fetches the data based on the URL created upon initialization
    func fetch(callback: (NSArray)->Void){
        let session = NSURLSession.sharedSession()
        
        // starts a task
        let task = session.dataTaskWithURL(self.url, completionHandler: {data, response, error -> Void in
            println("Task Completed!")
            if(error != nil){
                // Prints error to the console
                println(error.localizedDescription)
            }
            // A variable for a potential error
            var jsonError: NSError?
            // Parses the JSON and casts it as an NSDictionary
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary
            if(jsonError != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(jsonError!.localizedDescription)")
                println(self.url)
            } else {
                // Only takes the results of the search and casts as an NSArray
                if let results: NSArray = jsonResult!["results"] as? NSArray{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.data = results
                        callback(results)
                    })
                }
            }
            
            
        })

        // start the task
        task.resume()
        
        print(data.count)
        
        
    }
    
    
}
