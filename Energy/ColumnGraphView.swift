//
//  ColumnGraphView.swift
//  Energy
//
//  Created by Caleb Braun on 6/1/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

@IBDesignable class ColumnGraphView: UIView {
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    var dataPoints = [Double]()
    var resolution:String = ""
    
    override func drawRect(rect: CGRect) {
        
        // Graph variables
        let graphWidth = Double(rect.width)
        let graphHeight = Double(rect.height)
        let graphBottom = Double(graphHeight - 24)
        let graphLeft = 36.0
        let numberOfGridLines = 6.0
        var maxUnit:Double = 0
        var graphTopUnitValue:Double = 0
        
        if dataPoints.count > 0 {
            maxUnit = maxElement(dataPoints)
            graphTopUnitValue = ((2*numberOfGridLines)/(2*numberOfGridLines-1)) * maxUnit
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

        if maxUnit > 0 { // Check if there is actually data
            self.noDataLabel.hidden = true
            for i in 1..<Int(numberOfGridLines) {
                let yPoint:Double = graphBottom*(Double(i)/numberOfGridLines)
                gridLinesPath.moveToPoint(CGPoint(x:graphLeft, y:yPoint))
                let nextPoint = CGPoint(x:graphWidth, y:yPoint)
                gridLinesPath.addLineToPoint(nextPoint)
                
                var labelNum = (graphTopUnitValue * (numberOfGridLines - Double(i)) / (numberOfGridLines))
                
                if let labelView = self.viewWithTag(i) as? UILabel {
                    labelView.text = "\(labelNum)"
                } else {
                    var center = CGPoint(x: graphLeft/2, y: yPoint)
                    var valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat(graphLeft-2), height: 25.0))
                    valueLabel.center = center
                    valueLabel.tag = i
                    valueLabel.textAlignment = NSTextAlignment.Center
                    valueLabel.text = String(format: "%.2f",labelNum)
                    valueLabel.textColor = UIColor.blackColor()
                    valueLabel.font = UIFont(name: "Avenir Next Condensed", size: 20)
                    valueLabel.adjustsFontSizeToFitWidth = true
                    
                    self.addSubview(valueLabel)
                }
            }
        } else {
            self.noDataLabel.hidden = false
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
                barHeight = graphBottom - (graphBottom/graphTopUnitValue * energyValue)
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
            
            let valueTag = Int(numberOfGridLines) + (2*numBars)
            let nameTag = Int(numberOfGridLines + 1) + (2*numBars)
            var needNewLabels = true
            
            for view in self.subviews as! [UIView] {
                if let buildingLabel = view as? UILabel {
                    if buildingLabel.tag == Int(numberOfGridLines) + (2*numBars) {
                        buildingLabel.text = "\(energyValue)"
                        buildingLabel.frame.origin.y = CGFloat(barHeight - 15)
                    }
                    if buildingLabel.tag == Int(numberOfGridLines + 1) + (2*numBars) {
                        buildingLabel.text =  ""
                        needNewLabels = false
                    }
                }
            }
            
            if needNewLabels == true {
                var valueCenter = CGPoint(x: (right-(barWidth/2)), y: (barHeight - 10))
                var valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat(barWidth), height: 25.0))
                valueLabel.center = valueCenter
                valueLabel.tag = valueTag
                valueLabel.textAlignment = NSTextAlignment.Center
                valueLabel.text =  String(format: "%.2f", energyValue)
                valueLabel.textColor = UIColor(red: 0.235, green: 0.455, blue: 0.518, alpha: 1)
                valueLabel.font = UIFont(name: "Avenir Next Condensed-Bold", size: 20)
                valueLabel.adjustsFontSizeToFitWidth = true
                
                var nameCenter = CGPoint(x: (right-(barWidth/2)), y: (graphBottom + 12))
                var nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat(barWidth), height: 25.0))
                nameLabel.center = nameCenter
                nameLabel.tag = nameTag
                nameLabel.text = ""
                nameLabel.font = UIFont(name: "Avenir Next Condensed", size: 20)
                nameLabel.adjustsFontSizeToFitWidth = true
                
                self.addSubview(valueLabel)
                self.addSubview(nameLabel)
            }
            
            numBars+=1
            
            self.setNeedsDisplay()
        }
        
    }

}
