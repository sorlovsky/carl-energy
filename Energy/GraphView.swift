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
//

import UIKit

@IBDesignable class GraphView: UIView {
    
    //The properties for the background gradient
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    
//<<<<<<< HEAD
//    //Weekly sample datagi
//    var graphPoints:[Float] = [1,0,0,0,0,0,1]
//=======
    //Weekly sample data
    var graphPoints:[Double] = [1,0,0,0,0,0,1]

    
    override func drawRect(rect: CGRect) {
        
        if graphPoints.count == 0 {
            return
        }
        
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
        
        //calculate the x point
        let margin:Double = 20.0
        var columnXPoint = { (column:Int) -> Double in
            //Calculate gap between points
            let spacer = (width - margin*2 - 4.0) / Double(self.graphPoints.count - 1)
            var x:Double = Double(column) * spacer
            x += margin + 2
            return x
        }
            
        // calculate the y point
        let topBorder:Double = 60
        let bottomBorder:Double = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = maxElement(self.graphPoints)
        var columnYPoint = { (graphPoint:Double) -> Double in
            var y:Double = graphPoint / maxValue * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
        
        
        // draw the line graph
        
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        //set up the points line
        var graphPath = UIBezierPath()
        //go to start of line
        graphPath.moveToPoint(CGPoint(x:columnXPoint(0), y:columnYPoint(graphPoints[0])))
        
        //add points for each item in the graphPoints array
        //at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
            
            graphPath.addLineToPoint(nextPoint)
        }
        
        graphPath.stroke()
        
        //Draw the circles on top of graph stroke
//        for i in 0..<graphPoints.count {
//            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
//            point.x -= 5.0/2
//            point.y -= 5.0/2
//            
//            var circleSize = CGSize(width: 5.0, height: 5.0)
//            var circleRect = CGRect(origin: point, size: circleSize)
//            
//            let circle = UIBezierPath(ovalInRect: circleRect)
//            circle.fill()
//        }
        
        //Draw horizontal graph lines on the top of everything
        var linePath = UIBezierPath()
        
        //top line
        linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin,
            y:topBorder))
        
        //center line
        linePath.moveToPoint(CGPoint(x:margin,
            y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:graphHeight/2 + topBorder))
        
        //bottom line
        linePath.moveToPoint(CGPoint(x:margin,
            y:height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        println("here")

    }
    
    func drawGraphPoints(points : [Double]) {
        self.graphPoints = points
    }
    
}
