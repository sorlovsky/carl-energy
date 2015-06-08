//
//  ColumnGraphView.swift
//  Energy
//
//  Created by Caleb Braun on 6/1/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

@IBDesignable class ColumnGraphView: UIView {
    
    //var dataPoints = [Double]()
    var dataPoints = [3.0, 4.7, 6,9, 5.5, 1.1]
    var resolution:String = ""
    
    override func drawRect(rect: CGRect) {
        
        // Graph variables
        let graphWidth = Double(rect.width)
        let graphHeight = Double(rect.height)
        var maxUnit:Double = 0
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()
        
        // Draw the graph boundaries
        UIColor.blackColor().setStroke()
        var boundaryPath = UIBezierPath()
        boundaryPath.moveToPoint(CGPoint(x:1, y:2))
        boundaryPath.addLineToPoint(CGPoint(x:1, y:graphHeight-1))
        boundaryPath.addLineToPoint(CGPoint(x:graphWidth-1, y:graphHeight-1))
        boundaryPath.lineWidth = 2.0
        boundaryPath.stroke()
        
        // Set up the bars
        var numBars = 0
        var barHeight:Double = 0
        let barWidth = 25
        let rectanglePath = CGPathCreateMutable()
        
        // Draw the bars
        for energyValue in self.dataPoints {
            
            // Set up bar variables
            let left = Double(barWidth+(barWidth*numBars))
            let right = Double((barWidth*2)+(barWidth*numBars))
            
            if maxUnit > 0 {
                barHeight = (graphHeight/maxUnit * energyValue) * (5/6)
            }
            let points = [CGPoint(x:2, y:left), CGPoint(x:2, y:right), CGPoint(x:barHeight, y:right), CGPoint(x:barHeight, y:left)]
            
            // Draw the bar
            var startingPoint = points[0]
            CGPathMoveToPoint(rectanglePath, nil, startingPoint.x, startingPoint.y)
            for p in points {
                CGPathAddLineToPoint(rectanglePath, nil, p.x, p.y)
            }
            let barColor = UIColor(red: 0.8353, green: 0.4325, blue: 0.3608, alpha: 1)  //rgb = (213,108,92)
            CGPathCloseSubpath(rectanglePath)
            CGContextAddPath(context, rectanglePath)
            CGContextSetFillColorWithColor(context, barColor.CGColor)
            CGContextFillPath(context)
            
            // Make the bar labels – tags start at 6 because the scale values are 1 through 5
            let valueTag = 6 + numBars
            var needNewLabel = true
            
            for view in self.subviews as! [UIView] {
                if let buildingLabel = view as? UILabel {
                    if buildingLabel.tag == 6 + numBars {
                        buildingLabel.text = "\(energyValue)"
                    }
                }
            }
            
            if needNewLabel == true {
                
                var center = CGPoint(x: (left + Double(barWidth/2)), y: (barHeight - 25))
                
                var valueLabel = UILabel(frame: CGRect(x: center.x, y: center.y, width: 50.0, height: 25.0))
                valueLabel.tag = valueTag
                valueLabel.textAlignment = NSTextAlignment.Center
                valueLabel.text =  "\(energyValue)"
                valueLabel.textColor = UIColor(red: 0.235, green: 0.455, blue: 0.518, alpha: 1)
                valueLabel.font = UIFont(name: "Avenir Next Condensed-Bold", size: 20)
            
                self.addSubview(valueLabel)
            }
            
            // Draw a white line to separate the bars
            UIColor.whiteColor().setStroke()
            var boundaryPath = UIBezierPath()
            boundaryPath.moveToPoint(CGPoint(x:2, y:right))
            boundaryPath.addLineToPoint(CGPoint(x:barHeight, y:right))
            boundaryPath.lineWidth = 2.0
            boundaryPath.stroke()
            
            numBars+=1
            
            self.setNeedsDisplay()
        }
        
    }

}
