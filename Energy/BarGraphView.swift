//
//  BarGraphView.swift
//  Energy
//
//  Created by Caleb Braun on 5/18/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//
//  This is a template for how we will draw our bargraphs.  The graphs are drawn using Core Graphics.
//

import UIKit

@IBDesignable class BarGraphView: UIView {
    
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var buildingsDataDictionary = [String:Double]()
    
    override func drawRect(rect: CGRect) {
        
        let width = Double(rect.width)
        let height = Double(rect.height)
        
        //set up background clipping area
//        var path = UIBezierPath(roundedRect: rect,
//            byRoundingCorners: UIRectCorner.AllCorners,
//            cornerRadii: CGSize(width: 8.0, height: 8.0))
//        path.addClip()
        
        //Get the current context
        let context = UIGraphicsGetCurrentContext()
        
        //Draw the grid lines
        UIColor.grayColor().setFill()
        UIColor.grayColor().setStroke()
        var gridLinesPath = UIBezierPath()
        gridLinesPath.moveToPoint(CGPoint(x:50, y:20))
        //add 5 lines
        for i in 1...5 {
            let nextPoint = CGPoint(x:(50*i), y:300)
            gridLinesPath.addLineToPoint(nextPoint)
            gridLinesPath.moveToPoint(CGPoint(x:50*(i+1), y:20))
        }
        gridLinesPath.stroke()
        
        //add gridline labels
        for i in 1...5{
            if let labelView = self.viewWithTag(i) as? UILabel {
                if Array(buildingsDataDictionary.values).count != 0{
                    let maxValue = Array(buildingsDataDictionary.values)[0]
                    var maxNum = floor(maxValue/50)*50
                    var labelNum = (Int(maxNum) / 5) * i
                    labelView.text = "\(labelNum)"
                }
            }
        }
        
        //Draw the graph boundaries
        UIColor.blackColor().setStroke()
        var boundaryPath = UIBezierPath()
        boundaryPath.moveToPoint(CGPoint(x:1, y:height))
        boundaryPath.addLineToPoint(CGPoint(x:1, y:2))
        boundaryPath.addLineToPoint(CGPoint(x:width-1, y:2))
        boundaryPath.addLineToPoint(CGPoint(x:width-1, y:24))
        boundaryPath.addLineToPoint(CGPoint(x:1, y:24))
        boundaryPath.lineWidth = 2.0
        boundaryPath.stroke()
        
        //Draw the bars
        var numBars = 0
        for (buildingName, value) in buildingsDataDictionary{
            println("Building: \(buildingName) \n Value: \(value)")
            
            self.valueLabel.text = "\(value)"
            self.nameLabel.text = "\(buildingName)"
            
            let rectanglePath = CGPathCreateMutable()
            
            // Set up bar variables
            let maximumUnit = floor(value/50)*60
            var barLength:Double = 0
            if maximumUnit > 0{
                barLength = (300/maximumUnit * value)
            }
            let top = Double(25+(25*numBars))
            let bot = Double(50+(25*numBars))
            let points = [CGPoint(x:2, y:top), CGPoint(x:2, y:bot), CGPoint(x:barLength, y:bot), CGPoint(x:barLength, y:top)]
            
            // Draw the bar
            var startingPoint = points[0]
            CGPathMoveToPoint(rectanglePath, nil, startingPoint.x, startingPoint.y)
            for p in points {
                CGPathAddLineToPoint(rectanglePath, nil, p.x, p.y)
            }
            CGPathCloseSubpath(rectanglePath)
            CGContextAddPath(context, rectanglePath)
            CGContextSetFillColorWithColor(context, UIColor.orangeColor().CGColor)
            CGContextFillPath(context)
            
            // Draw a line to separate the bars
            UIColor.whiteColor().setStroke()
            var boundaryPath = UIBezierPath()
            boundaryPath.moveToPoint(CGPoint(x:2, y:bot))
            boundaryPath.addLineToPoint(CGPoint(x:barLength, y:bot))
            boundaryPath.lineWidth = 2.0
            boundaryPath.stroke()
            
            numBars+=1
        }
        self.setNeedsDisplay()
    }
    
    func loadData(buildingData: [String:[Double]]){
        // Calculates the total
        for (name, data) in buildingData{
            print("name: ")
            println(name)
            print("data")
            println(data)
            self.buildingsDataDictionary[name] = round(100 * (data.reduce(0, combine: +))) / 100
        }
    }

    
    
}

