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
    var dataPoints = [3.0, 4.7, 6.9, 5.5, 1.1, 8.5, 0.3, 12.0, 7.3, 2.3]
    var resolution:String = ""
    
    override func drawRect(rect: CGRect) {
        
        // Graph variables
        let graphWidth = Double(rect.width)
        let graphHeight = Double(rect.height)
        let graphBottom = Double(graphHeight - 24)
        let graphLeft = 36.0
        let numberOfGridLines = 6.0
        var maxUnit:Double = 0
        
        if dataPoints.count > 0 {
            maxUnit = maxElement(dataPoints)
        }
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()
        
        // Draw the graph axes
        UIColor.blackColor().setStroke()
        var boundaryPath = UIBezierPath()
        boundaryPath.moveToPoint(CGPoint(x:graphLeft, y:graphHeight-1))
        boundaryPath.addLineToPoint(CGPoint(x:graphLeft, y:0))
        boundaryPath.moveToPoint(CGPoint(x:graphLeft, y:graphBottom))
        boundaryPath.addLineToPoint(CGPoint(x:graphWidth, y:graphBottom))
        boundaryPath.lineWidth = 0.5
        boundaryPath.stroke()
        
        // Draw the grid lines
        UIColor.grayColor().setFill()
        UIColor.grayColor().setStroke()
        var gridLinesPath = UIBezierPath()

        for i in 1..<Int(numberOfGridLines) {
            let yPoint:Double = graphBottom*(Double(i)/numberOfGridLines)
            gridLinesPath.moveToPoint(CGPoint(x:graphLeft, y:yPoint))
            let nextPoint = CGPoint(x:graphWidth, y:yPoint)
            gridLinesPath.addLineToPoint(nextPoint)
            
            // graphBottom = (maxUnit * ratio) + topSpacer
            // graphBottom - topSpacer = maxUnit * ratio
            // graphBottom - topSpacer = maxUnit * (6/5 top label value / graphBottom)
            let topSpacer = maxUnit/(2*numberOfGridLines)
            var labelNum = round(maxUnit * (numberOfGridLines - Double(i)) / (numberOfGridLines))
            
            if let labelView = self.viewWithTag(i) as? UILabel {
                labelView.text = "\(labelNum)"
            } else {
                var center = CGPoint(x: graphLeft/2, y: yPoint)
                var valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat(graphLeft), height: 25.0))
                valueLabel.center = center
                valueLabel.tag = i
                valueLabel.textAlignment = NSTextAlignment.Center
                valueLabel.text =  "\(labelNum)"
                valueLabel.textColor = UIColor.blackColor()
                valueLabel.font = UIFont(name: "Avenir Next Condensed", size: 20)
                valueLabel.adjustsFontSizeToFitWidth = true
                
                self.addSubview(valueLabel)
            }
        }
        gridLinesPath.stroke()
        
        
        // Set up the bars
        var numBars:Int = 0
        let barSpacing:Double = 50/Double(dataPoints.count)
        let barWidth:Double = (graphWidth - graphLeft - (Double(dataPoints.count)) * (barSpacing+1)) / (Double(dataPoints.count))
        var barHeight:Double = 0
        let rectanglePath = CGPathCreateMutable()
        
        // Draw the bars
        for energyValue in self.dataPoints {
            
            // Set up bar variables
            let left = (barSpacing*(Double(numBars)+1))+(barWidth*Double(numBars)) + graphLeft
            let right = left+Double(barWidth)
            
            if maxUnit > 0 {
                barHeight = graphBottom - (graphBottom/maxUnit * energyValue)
            }
            let points = [CGPoint(x:left, y:graphBottom), CGPoint(x:right, y:graphBottom), CGPoint(x:right, y:barHeight), CGPoint(x:left, y:barHeight)]
            
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
                var center = CGPoint(x: (right-(barWidth/2)), y: (barHeight - 15))
                var valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat(barWidth), height: 25.0))
                valueLabel.center = center
                valueLabel.tag = valueTag
                valueLabel.textAlignment = NSTextAlignment.Center
                valueLabel.text =  "\(energyValue)"
                valueLabel.textColor = UIColor(red: 0.235, green: 0.455, blue: 0.518, alpha: 1)
                valueLabel.font = UIFont(name: "Avenir Next Condensed-Bold", size: 20)
                valueLabel.adjustsFontSizeToFitWidth = true
            
                self.addSubview(valueLabel)
            }
            
            numBars+=1
            
            self.setNeedsDisplay()
        }
        
    }

}
