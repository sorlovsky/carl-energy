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
    
    var buildings = [String]()
    var buildingValue = [Double]()
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
        
        
        //buildingsDataDictionary[buildings[0]] = buildingValue[0]
        
        // draw a bar graph
        for (buildingName, value) in buildingsDataDictionary{
            
            valueLabel.text = "\(value)"
            
            let rectanglePath = CGPathCreateMutable()
            
            let points = [CGPoint(x:0, y:25), CGPoint(x:0, y:50), CGPoint(x:width-20, y:50), CGPoint(x:width-20, y:25)]
            var cpg = points[0]
            CGPathMoveToPoint(rectanglePath, nil, cpg.x, cpg.y)
            for p in points {
                CGPathAddLineToPoint(rectanglePath, nil, p.x, p.y)
            }
            CGPathCloseSubpath(rectanglePath)
            
            CGContextAddPath(context, rectanglePath)
            CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
            CGContextFillPath(context)
        }
        

    }

    
    
}

