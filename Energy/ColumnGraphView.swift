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
    var dataPoints = [3.0, 4.7, 6.9, 5.5, 1.1]
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
        
        // Draw the grid lines
        UIColor.grayColor().setFill()
        UIColor.grayColor().setStroke()
        var gridLinesPath = UIBezierPath()
        gridLinesPath.moveToPoint(CGPoint(x:1, y:50))
        //Add 5 lines
        for i in 1...5 {
            let nextPoint = CGPoint(x:graphWidth, y:Double(50*i))
            gridLinesPath.addLineToPoint(nextPoint)
            gridLinesPath.moveToPoint(CGPoint(x:1, y:Double(50*(i+1))))
        }
        gridLinesPath.stroke()
        
        maxUnit = maxElement(dataPoints)
        
        // Set up the bars
        var numBars = 0
        var barHeight:Double = 0
        let barWidth = 25
        let barSpacing = 10
        let rectanglePath = CGPathCreateMutable()
        
        // Draw the bars
        for energyValue in self.dataPoints {
            
            // Set up bar variables
            let left = Double((barSpacing*(numBars+1))+(barWidth*numBars))
            let right = left+Double(barWidth)
            
            if maxUnit > 0 {
                barHeight = graphHeight - ((graphHeight/maxUnit * energyValue) * (5/6))
            }
            let points = [CGPoint(x:left, y:graphHeight), CGPoint(x:right, y:graphHeight), CGPoint(x:right, y:barHeight), CGPoint(x:left, y:barHeight)]
            
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
                
                var center = CGPoint(x: left, y: (barHeight - 25))
                
                var valueLabel = UILabel(frame: CGRect(x: center.x, y: center.y, width: CGFloat(barWidth), height: 25.0))
                valueLabel.tag = valueTag
                valueLabel.textAlignment = NSTextAlignment.Right
                valueLabel.text =  "\(energyValue)"
                valueLabel.textColor = UIColor(red: 0.235, green: 0.455, blue: 0.518, alpha: 1)
                valueLabel.font = UIFont(name: "Avenir Next Condensed-Bold", size: 20)
            
                self.addSubview(valueLabel)
            }
            
            // Draw a vertical white line to separate the bars
            UIColor.whiteColor().setStroke()
            var boundaryPath = UIBezierPath()
            boundaryPath.moveToPoint(CGPoint(x:left, y:graphHeight-2))
            boundaryPath.addLineToPoint(CGPoint(x:left, y:barHeight))
            boundaryPath.lineWidth = 2.0
            boundaryPath.stroke()
            
            numBars+=1
            
            self.setNeedsDisplay()
        }
        
    }

}
