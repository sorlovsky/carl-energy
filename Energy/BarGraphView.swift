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
        

        
        
        // draw a bar graph
        let origin : CGPoint = CGPoint(x:55,y:75)
        let size : CGSize = CGSize(width:CGFloat(50), height:CGFloat(50))
        var bar : CGRect = CGRect(origin:origin, size:size)
        
        
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        
        //Draw horizontal graph lines on the top of everything
        var linePath = UIBezierPath()
        
        
    }
    
    
}

