//
//  GraphViewController.swift
//  Energy
//
//  Created by mobiledev on 5/18/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    
    //Label outlets
    @IBOutlet weak var averageEnergyProduced: UILabel!
    @IBOutlet weak var totalEnergyProduced: UILabel!
    @IBOutlet weak var maxLabel: UILabel!

    var buildingName = String()
    
    var sampleWindData:[Int] = [3, 4, 8, 9, 3, 2, 1]
    var actualData:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        println(buildingName)
        let searchName = "carleton_\(buildingName.lowercaseString)_en_use"
        // Sample date data
        let dateComponents = NSDateComponents()
        dateComponents.year = 2015
        dateComponents.month = 05
        dateComponents.day = 11
        let startDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        dateComponents.day = 17
        let endDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        
        let data : DataRetreiver = DataRetreiver()
        data.fetch(searchName, startDate: startDate, endDate: endDate, resolution: "day", callback: setupGraphDisplay)
        
    }


    func setupGraphDisplay(results:NSArray) {
        println(results)
        self.actualData = results as [Int]
        
        //println(self.actualData)
        
        //Use 7 days for graph - can use any number,
        //but labels and sample data are set up for 7 days
        let noOfDays:Int = 7
        
        //1 - replace last day with today's actual data
        graphView.graphPoints[graphView.graphPoints.count-1] = actualData[actualData.count-1]
        
        println(graphView.graphPoints)
        
        //2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        
        maxLabel.text = "\(maxElement(graphView.graphPoints))"
        
        //3 - calculate average and total from graphPoints
        let total = graphView.graphPoints.reduce(0, combine: +)
        let average = total / graphView.graphPoints.count
        averageEnergyProduced.text = "\(average)"
        totalEnergyProduced.text = "\(total)"
        
        
        
        //set up labels
        //day of week labels are set up in storyboard with tags
        //today is last day of the array need to go backwards
        
        //4 - get today's day number
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .CalendarUnitWeekday
        let components = calendar.components(componentOptions,
            fromDate: NSDate())
        var weekday = components.weekday
        
        let days = ["S", "S", "M", "T", "W", "T", "F"]
        
        //5 - set up the day name labels with correct day
        for i in reverse(1...days.count) {
            if let labelView = graphView.viewWithTag(i) as? UILabel {
                if weekday == 7 {
                    weekday = 0
                }
                labelView.text = days[weekday--]
                if weekday < 0 {
                    weekday = days.count - 1
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
