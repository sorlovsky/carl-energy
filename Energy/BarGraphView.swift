//  
//  DetailConsumptionViewController.swift
//  Carleton Energy App
//  6/8/2015
//
//  By Hami Abdi, Caleb Braun, and Simon Orlovsky
//
//  A view for representing multiple building's energy data on a bar graph
//


import UIKit

@IBDesignable class BarGraphView: UIView {
    
    var buildingNames = [String]()
    var buildingData = [Double]()
    
    override func drawRect(rect: CGRect) {
        
        // Graph variables
        let graphWidth = Double(rect.width)
        let graphHeight = Double(rect.height)
        var maxUnit:Double = 0
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()
        
        // Draw the grid lines
        UIColor.grayColor().setFill()
        UIColor.grayColor().setStroke()
        var gridLinesPath = UIBezierPath()
        gridLinesPath.moveToPoint(CGPoint(x:50, y:20))
        //Add 5 lines
        for i in 1...5 {
            let nextPoint = CGPoint(x:(50*i), y:300)
            gridLinesPath.addLineToPoint(nextPoint)
            gridLinesPath.moveToPoint(CGPoint(x:50*(i+1), y:20))
        }
        gridLinesPath.stroke()
        
        // Add the gridline labels
        for i in 1...5 {
            if let labelView = self.viewWithTag(i) as? UILabel {
                if self.buildingNames.count != 0 {
                    maxUnit = self.buildingData[0]
                    if maxUnit > 0 {
                        var labelNum = Int(maxUnit / 5) * i
                        // floor(self.buildingData[0]/50)*50
                        
                        labelView.text = "\(labelNum)"
                    }
                }
            }
        }
        
        // Draw the graph boundaries
        UIColor.blackColor().setStroke()
        var boundaryPath = UIBezierPath()
        boundaryPath.moveToPoint(CGPoint(x:1, y:graphHeight))
        boundaryPath.addLineToPoint(CGPoint(x:1, y:2))
        boundaryPath.addLineToPoint(CGPoint(x:graphWidth-1, y:2))
        boundaryPath.addLineToPoint(CGPoint(x:graphWidth-1, y:24))
        boundaryPath.addLineToPoint(CGPoint(x:1, y:24))
        boundaryPath.lineWidth = 2.0
        boundaryPath.stroke()
        
        // Draw the bars
        var numBars = 0
        for buildingIndex in 0..<self.buildingNames.count {
//            println("Building: \(buildingName) \n Value: \(value)")
            
            let rectanglePath = CGPathCreateMutable()
            
            // Set up bar variables
            let barWidth = 25
            var barLength:Double = 0
            let top = Double(barWidth+(barWidth*numBars))
            let bot = Double((barWidth*2)+(barWidth*numBars))
            
            if maxUnit > 0 {
                barLength = (graphWidth/maxUnit * self.buildingData[buildingIndex]) * (5/6)
            }
            let points = [CGPoint(x:2, y:top), CGPoint(x:2, y:bot), CGPoint(x:barLength, y:bot), CGPoint(x:barLength, y:top)]
            
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
            let nameTag = 6 + (2*numBars)
            let valueTag = 7 + (2*numBars)
            var needNewLabels = true
            
            for view in self.subviews as! [UIView] {
                if let buildingLabel = view as? UILabel {
                    if buildingLabel.tag == 6 + (2*numBars) {
                        buildingLabel.text = "\(self.buildingNames[buildingIndex])"
                    }
                    if buildingLabel.tag == 7 + (2*numBars) {
                        buildingLabel.text =  "\(self.buildingData[buildingIndex])"
                        buildingLabel.frame.origin.x = CGFloat(barLength-205)
                        needNewLabels = false
                    }
                }
            }
            
            if needNewLabels == true {
                let fontSize:CGFloat = 20
                var nameLabel = UILabel(frame: CGRect(x: 5, y: top, width: 200.0, height: 25.0))
                nameLabel.tag = nameTag
                nameLabel.text = "\(self.buildingNames[buildingIndex])"
                nameLabel.font = UIFont(name: "Avenir Next Condensed", size: fontSize)
                nameLabel.sizeToFit()
                
                var xpos = barLength-205
                var textAlign = NSTextAlignment.Right
                if barLength < graphWidth * 2/3 {
                    xpos = Double(nameLabel.frame.width+20)
                    println(xpos)
                    textAlign = NSTextAlignment.Left
                }
                var valueLabel = UILabel(frame: CGRect(x: xpos, y: top, width: 200.0, height: 25.0))
                valueLabel.tag = valueTag
                valueLabel.textAlignment = textAlign
                valueLabel.text =  "\(self.buildingData[buildingIndex])"
                valueLabel.textColor = UIColor(red: 0.235, green: 0.455, blue: 0.518, alpha: 1)
                valueLabel.font = UIFont(name: "Avenir Next Condensed-Bold", size: fontSize)
                
                self.addSubview(nameLabel)
                self.addSubview(valueLabel)
            }
            
            // Draw a white line to separate the bars
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
    
    func loadData(buildingData: [String:[Double]]) {
        // Sort the dictionary
        var newDictionary = [String:Double]()
        for (building, energyValue) in buildingData {
            newDictionary[building] = round(100 * (energyValue.reduce(0, combine: +))) / 100
        }
    
        var energyValues = Array(newDictionary.values)
        energyValues.sort {$0 > $1}
        
        self.buildingNames.removeAll(keepCapacity: true)
        self.buildingData.removeAll(keepCapacity: true)
        
        for number in energyValues {
            for (building, value) in newDictionary {
                if value == number {
                    self.buildingNames.append(building)
                    self.buildingData.append(value)
                    newDictionary[building] = nil
                    break
                }
            }
        }
        
    }
    
}

