//
//  GraphViewController.swift
//  Energy
//
//  Created by Caleb Braun on 5/18/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//
//  This is a template for how we will draw our graphs.  The graphs are drawn using Core Graphics.
//
//  Most of the graph display is based off of the tutorial found here: http://www.raywenderlich.com/90693/modern-core-graphics-with-swift-part-2

// Received help on getting max Double from an array from http://stackoverflow.com/questions/24036514/correct-way-to-find-max-in-an-array-in-swift
//

import UIKit

@IBDesignable class GraphView: UIView {
    
    //The properties for the background gradient
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    
    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var averageEnergyText: UILabel!
    @IBOutlet weak var totalEnergyText: UILabel!
    
    var maximumNumberOfItems: Int = 0
    var Turbine1Production: [Double] = []
    var Turbine2Production: [Double] = []
    var Turbine2Speed: [Double] = []
    var SolarPV: [Double] = []
    
    let NUM_TODAY: Int = 24
    let NUM_4WKS: Int = 28
    let NUM_LASTYR: Int = 12
    let NUM_LASTWK: Int = 7
    
//    var labels = [UILabel]()
    
    override func drawRect(rect: CGRect) {
        let producers: [[Double]] = [Turbine1Production, Turbine2Production, SolarPV]
        
        //Set the graph variables
        let width = Double(rect.width)
        let height = Double(rect.height)
        let margin:Double = 20.0
        let topBorder:Double = 60
        let bottomBorder:Double = 50
        var productionPoints = [Double]()
        
        //Calculate the x point
        var columnXPoint = { (column:Int) -> Double in
            //Calculate gap between points
//            let spacer = (width - margin*2 - 4.0) / Double(productionPoints.count - 1)
            let spacer = (width-margin*2 - 4.0)/Double(self.maximumNumberOfItems-1)
            var x:Double = Double(column) * spacer
            x += margin + 2
            return x
        }
        
        //Calculate the y point
        let graphHeight = height - topBorder - bottomBorder
//        let maxValue = maxElement(productionPoints)
        var columnYPoint = { (graphPoint:Double) -> Double in
//            var y:Double = graphPoint / maxValue * graphHeight
            var y: Double = graphPoint
//            var y:Double = graphPoint
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
        // find the max production
        var maxProduction: Double = 0
        if Turbine1Production.count > 0{
            if Turbine2Production.count>0{
                maxProduction = max(maxElement(Turbine1Production),maxElement(Turbine2Production))
            }else{
                maxProduction = maxElement(Turbine1Production)
            }
        } else{
            if Turbine2Production.count>0{
                maxProduction = maxElement(Turbine2Production)
            }
        }
        if SolarPV.count > 0{
            maxProduction = max(maxProduction, maxElement(SolarPV))
        }
        
        //Create the line graph
        var graphPath = UIBezierPath()
        for producer in producers{
            if producer.count > 0{
                var graphPoints = [Double]()
                for i in producer{
                    graphPoints.append(i)
                }
                var yPoint: Double?
                for i in 0..<graphPoints.count{
                    graphPoints[i] = (graphPoints[i]*graphHeight)/(maxProduction)
                }
                graphPath.moveToPoint(CGPoint(x:columnXPoint(0), y:columnYPoint(graphPoints[0])))
                
                for i in 1..<graphPoints.count{
                    let nextPoint = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
                    graphPath.addLineToPoint(nextPoint)
                }
                
                UIColor.whiteColor().setFill()
                UIColor.whiteColor().setStroke()
                graphPath.stroke()
                
                //Draw the circles on top of graph stroke
                let circleSize = CGSize(width: 5.0, height: 5.0)
                for i in 0..<graphPoints.count {
                    var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
                    point.x -= circleSize.width/2
                    point.y -= circleSize.height/2
                    var circleRect = CGRect(origin: point, size: circleSize)
                    let circle = UIBezierPath(ovalInRect: circleRect)
                    circle.fill()
                }
                
                //Draw horizontal graph lines on the top of everything
                var linePath = UIBezierPath()
                
                //Top line
                linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
                linePath.addLineToPoint(CGPoint(x: width - margin,
                    y:topBorder))
                
                //Center line
                linePath.moveToPoint(CGPoint(x:margin,
                    y: graphHeight/2 + topBorder))
                linePath.addLineToPoint(CGPoint(x:width - margin,
                    y:graphHeight/2 + topBorder))
                
                //Bottom line
                linePath.moveToPoint(CGPoint(x:margin,
                    y:height - bottomBorder))
                linePath.addLineToPoint(CGPoint(x:width - margin,
                    y:height - bottomBorder))
                let color = UIColor(white: 1.0, alpha: 0.3)
                color.setStroke()
                
                linePath.lineWidth = 1.0
                linePath.stroke()
            }
        }
        
        if Turbine2Speed.count > 0{
            var speedScaledPoints = [Double]()
            let maxSpeed = maxElement(Turbine2Speed)
            for i in Turbine2Speed{
                let valToAdd: Double = (i*graphHeight)/(maxSpeed)
                speedScaledPoints.append(valToAdd)
            }
            graphPath.moveToPoint(CGPoint(x:columnXPoint(0), y:columnYPoint(speedScaledPoints[0])))
            
            for i in 1..<speedScaledPoints.count{
                let nextPoint = CGPoint(x:columnXPoint(i), y:columnYPoint(speedScaledPoints[i]))
                graphPath.addLineToPoint(nextPoint)
            }
            
            UIColor.redColor().setFill()
            UIColor.redColor().setStroke()
            graphPath.stroke()
            
            //Draw the circles on top of graph stroke
            let circleSize = CGSize(width: 5.0, height: 5.0)
            for i in 0..<speedScaledPoints.count {
                var point = CGPoint(x:columnXPoint(i), y:columnYPoint(speedScaledPoints[i]))
                point.x -= circleSize.width/2
                point.y -= circleSize.height/2
                var circleRect = CGRect(origin: point, size: circleSize)
                let circle = UIBezierPath(ovalInRect: circleRect)
                circle.fill()
            }
            
            //Draw horizontal graph lines on the top of everything
            var linePath = UIBezierPath()
            
            //Top line
            linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
            linePath.addLineToPoint(CGPoint(x: width - margin,
                y:topBorder))
            
            //Center line
            linePath.moveToPoint(CGPoint(x:margin,
                y: graphHeight/2 + topBorder))
            linePath.addLineToPoint(CGPoint(x:width - margin,
                y:graphHeight/2 + topBorder))
            
            //Bottom line
            linePath.moveToPoint(CGPoint(x:margin,
                y:height - bottomBorder))
            linePath.addLineToPoint(CGPoint(x:width - margin,
                y:height - bottomBorder))
            let color = UIColor(white:1.0, alpha: 0.3)
            color.setStroke()
            
            linePath.lineWidth = 1.0
            linePath.stroke()
            
        }
    }

    
    func drawGraphPoints(){
        // The idea behind this structure, coupled with the discrete arrays (e.g. Turbine1Speed) is that it allows for very easy customization of the various views regarding Turbine 1, 2, and Solar PV. There was not enough time to account for all of the possibilities, but the structure should be hopefully enough to show where this idea was heading, and what can be achieved. The code for the toggle wind speed is not completely correct, which is why it is commented out; however, given a few more hours, it could be working.
        if Turbine1Production.count > 0{
            println("hello")
        }else{
            if Turbine2Production.count > 0{
                println("going through Turbine 2")
                if Turbine2Speed.count > 0{
                    let maxSpeedVal = maxElement(self.Turbine2Speed)
                    let total = Turbine2Production.reduce(0, combine: +)
                    let average = total / Double(Turbine2Production.count)
                    
                    //Indicate that the graph needs to be redrawn and labels updated on the main queue
                    dispatch_async(dispatch_get_main_queue()){
                        //Round values to 100s places
                        self.maxLabel.text = "\(Int(maxElement(self.Turbine2Production)))"
                        self.maxSpeedLabel.text = "\(Int(maxElement(self.Turbine2Speed)))"
                        
                        self.averageEnergyText.text = "Average Energy Produced(kWH)\(round(100 * average) / 100)"
                        self.totalEnergyText.text = "Total Energy Produced(kWH): \(round(100 * total) / 100)"
                        self.setNeedsDisplay()

                        switch(self.maximumNumberOfItems){
                            case self.NUM_LASTWK:
                                let calendar = NSCalendar.currentCalendar()
                                let componentOptions:NSCalendarUnit = .CalendarUnitWeekday
                                let components = calendar.components(componentOptions,
                                    fromDate: NSDate())
                                var weekday = components.weekday
                                
                                //Set up the day name labels with correct day
                                let days = ["S", "S", "M", "T", "W", "T", "F"]
                                for i in reverse(1...days.count) {
                                    if let labelView = self.viewWithTag(i) as? UILabel {
                                        if weekday == 7 {
                                            weekday = 0
                                        }
                                        if weekday < 0 {
                                            weekday = days.count - 1
                                        }
                                        labelView.text = days[weekday]
                                        weekday = weekday-1
                                    }
                                }
                            default:
                                println("done for now")
                        }
                    }
                }else{
                    if SolarPV.count > 0{
                        println("SolarPV Stuff is also good")
//                    } else {
//                        println("made it here")
//                        let total = Turbine2Production.reduce(0, combine: +)
//                        let average = total / Double(Turbine2Production.count)
//                        
//                        //Indicate that the graph needs to be redrawn and labels updated on the main queue
//                        dispatch_async(dispatch_get_main_queue()){
//                            //Round values to 100s places
//                            self.maxLabel.text = "\(Int(maxElement(self.Turbine2Production)))"
//                            
//                            self.averageEnergyText.text = "Average Energy Produced(kWH)\(round(100 * average) / 100)"
//                            self.totalEnergyText.text = "Total Energy Produced(kWH): \(round(100 * total) / 100)"
//                            self.setNeedsDisplay()
//                        }
//                        switch(self.maximumNumberOfItems){
//                        case self.NUM_LASTWK:
//                            let dateFormatter = NSDateFormatter()
//                            let calendar = NSCalendar.currentCalendar()
//                            let componentOptions:NSCalendarUnit = .CalendarUnitWeekday
//                            let components = calendar.components(componentOptions, fromDate: NSDate())
//                            var weekday = components.weekday
//                            
//                            let days = ["S", "S", "M", "T", "W", "T", "F"]
//                            for i in reverse(1...days.count){
//                                if let labelView = self.viewWithTag(i) as? UILabel{
//                                    if weekday == 7{
//                                        weekday = 0
//                                    }
//                                    dispatch_sync(dispatch_get_main_queue()){
//                                        if weekday < 0{
//                                            weekday = days.count - 1
//                                        }
//                                        labelView.text = days[weekday]
//                                        weekday = weekday-1
//                                    }
//                                }
//                            }
//                        default:
//                            println("hi")
//                        }
                    }
                }
            }
        }
    }
}