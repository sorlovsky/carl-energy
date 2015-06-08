//
//  GraphViewController.swift
//  Energy
//
//  Created by Caleb Braun on 5/18/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//
//  This is a template for how our graph views will look.  The GraphViewController contains a Graph View inside of
//  Container View inside of a View.  This layering is done so that we will be able to add more elements in the most
//  helpful places.  These elements will include various ways the user can view the data (time period), which buildings
//  they want to see, and which type of energy use they want to select (electricity, steam, water, total BTU).
//
//  Most of the graph display is based off of the tutorial found here: http://www.raywenderlich.com/90693/modern-core-graphics-with-swift-part-2




import UIKit

class GraphViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    
    var switch_status: Int = 1
    
    let TURBINE1: String = "carleton_turbine1_produced_power"
    let TURBINE2: String = "carleton_wind_production"
    let TURBINE2SPEED: String = "carleton_wind_speed"
    let SOLARPV: String = "carleton_campus_total_pv_prod"
    
    let LAST4WKS: String = "last4weeks"
    let LASTWK: String = "lastweek"
    let LASTYR: String = "lastyear"
    let TODAY: String = "today"
    
    let NUM_TODAY: Int = 24
    let NUM_4WKS: Int = 28
    let NUM_LASTYR: Int = 12
    let NUM_LASTWK: Int = 7
    
    var period: String?
    
//    var desiredData = [String]()
    
    // This function gets called whenever the view appears from a segue from the ProductionViewController
    override func viewWillAppear(animated: Bool) {
        println("secondhello")

        // For now let's just focus on electricity
        let data: DataRetreiver = DataRetreiver()
        period = LASTWK
        
        data.fetchOverTimePeriod(TURBINE2, timePeriod: LASTWK, callback: setupGraphDisplay)
        data.fetchOverTimePeriod(TURBINE2SPEED, timePeriod: LASTWK, callback: setupGraphDisplay)
    }


    func setupGraphDisplay(results:[String:[Double]]) {
        let dataArray = results
        let nameOfProducer = (results.keys.array)[0]
        println(nameOfProducer)
        switch(period!){
            case LAST4WKS:
                graphView.maximumNumberOfItems = NUM_4WKS
            case LASTWK:
                graphView.maximumNumberOfItems = NUM_LASTWK
            case LASTYR:
                graphView.maximumNumberOfItems = NUM_LASTYR
            case TODAY:
                graphView.maximumNumberOfItems = NUM_TODAY
            default:
                graphView.maximumNumberOfItems = NUM_LASTWK
        }
        switch(nameOfProducer){
            case TURBINE1:
                graphView.Turbine1Production = dataArray[nameOfProducer]!
            case TURBINE2:
                graphView.Turbine2Production = dataArray[nameOfProducer]!
            case TURBINE2SPEED:
                graphView.Turbine2Speed = dataArray[nameOfProducer]!
            case SOLARPV:
                graphView.SolarPV = dataArray[nameOfProducer]!
            default:
                println("error in format of results")
        }
        
        graphView.drawGraphPoints()
        
    }
    
    @IBAction func showWindSpeedSwitch(sender: AnyObject) {
        //Please refer to the code in graphView.drawGraphPoint to see why the code below is commented out. tl;dr we ran out of time, but given a few more hours, it could be implemented. 
//        switch(switch_status){
//            case 1:
//                switch_status = 0
//                graphView.TURBINE2SPEED = []
//                graphView.drawGraphPoints()
//            case 0:
//                switch_status = 1
//                let data: DataRetreiver = DataRetreiver()
//                data.fetchOverTimePeriod(TURBINE2SPEED, timePeriod: self.period!, callback: setupGraphDisplay)
//            default:
//                println("something bad happened.")
//        }
    }
}
