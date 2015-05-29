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
    
    //The properties for the background gradient
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var buildings = ["Burton"]
    var buildingValue = [155.0]
    var buildingsDataDictionary = [String:Double]()
    
    override func drawRect(rect: CGRect) {
        
        let width = Double(rect.width)
        let height = Double(rect.height)
        
        
        //set up background clipping area
        var path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSize(width: 8.0, height: 8.0))
        path.addClip()
        
        //Drawing the gradient: First needs to get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        //set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        
        //draw the gradient
        var startPoint = CGPoint.zeroPoint
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context,
            gradient,
            startPoint,
            endPoint,
            0)
        
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
        
        // draw a bar graph
        for (buildingName, value) in buildingsDataDictionary{
            
            self.valueLabel.text = "\(value)"
            self.nameLabel.text = "\(buildingName)"
            
            let rectanglePath = CGPathCreateMutable()
            
            let maximumUnit = floor(value/50)*60
            var barLength:Double = 0
            if maximumUnit > 0{
                barLength = (300/maximumUnit * value)
            }
            let points = [CGPoint(x:0, y:25), CGPoint(x:0, y:50), CGPoint(x:barLength, y:50), CGPoint(x:barLength, y:25)]
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

