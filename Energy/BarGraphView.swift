//
//  BarGraphView.swift
//  Energy
//
//  Created by Caleb Braun on 5/18/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//
//  This is a template for how we will draw our bargraphs.  The graphs are drawn using Core Graphics.
//
//  Most of the graph display is based off of the tutorial found here: http://www.raywenderlich.com/90693/modern-core-graphics-with-swift-part-2
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
        
        //Draw the grid boundaries
        UIColor.blackColor().setStroke()
        var boundaryPath = UIBezierPath()
        boundaryPath.moveToPoint(CGPoint(x:2, y:height))
        boundaryPath.addLineToPoint(CGPoint(x:2, y:2))
        boundaryPath.addLineToPoint(CGPoint(x:width-2, y:2))
        boundaryPath.addLineToPoint(CGPoint(x:width-2, y:20))
        boundaryPath.addLineToPoint(CGPoint(x:2, y:20))
        boundaryPath.lineWidth = 2.0
        boundaryPath.stroke()
        
        //Draw the grid lines
        UIColor.grayColor().setFill()
        UIColor.grayColor().setStroke()
        
        var graphPath = UIBezierPath()
        //go to start of line
        graphPath.moveToPoint(CGPoint(x:50, y:20))
        
        //add 5 lines
        for i in 1...5 {
            let nextPoint = CGPoint(x:(50*i), y:300)
            graphPath.addLineToPoint(nextPoint)
            graphPath.moveToPoint(CGPoint(x:50*(i+1), y:20))
        }
        
        //add line labels
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
        
        graphPath.stroke()
        
        println(buildingsDataDictionary)
        var numBars = 0
        // draw a bar graph
        for (buildingName, value) in buildingsDataDictionary{
            numBars+=1
            
            self.valueLabel.text = "\(value)"
            self.nameLabel.text = "\(buildingName)"
            
            let rectanglePath = CGPathCreateMutable()
            
            let maximumUnit = floor(value/50)*60
            var barLength:Double = 0
            if maximumUnit > 0{
                barLength = (300/maximumUnit * value)
            }
            let top = Double(25*numBars)
            let bot = Double(50*numBars)
            let points = [CGPoint(x:0, y:top), CGPoint(x:0, y:bot), CGPoint(x:barLength, y:bot), CGPoint(x:barLength, y:top)]
            var startingPoint = points[0]
            CGPathMoveToPoint(rectanglePath, nil, startingPoint.x, startingPoint.y)
            for p in points {
                CGPathAddLineToPoint(rectanglePath, nil, p.x, p.y)
            }
            CGPathCloseSubpath(rectanglePath)
            
            CGContextAddPath(context, rectanglePath)
            CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
            CGContextFillPath(context)
        }
        
        self.setNeedsDisplay()
        
    }
    
    func loadData(name: String, data : [Double]){
        self.buildingsDataDictionary[name] = round(100 * (data.reduce(0, combine: +))) / 100
    }

    
    
}

