//
//  BuildingsDictionary.swift
//  Energy
//
//  Created by Caleb Braun on 6/6/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

class BuildingsDictionary {
    
    let path: String?
    var buildingsDictionaries: NSArray!
    
    init() {
        self.path = NSBundle.mainBundle().pathForResource("buildings", ofType: "plist")
        self.buildingsDictionaries = NSArray(contentsOfFile: path!)!
    }
    
    func getBuildingNames() -> [String] {
        var buildingNames = [String]()
        for dict in self.buildingsDictionaries {
            let name = dict["displayName"] as! String
            buildingNames.append(name)
        }
        return buildingNames
    }
    
    func getBuildingImages() -> [String] {
        var buildingImages = [String]()
        for dict in self.buildingsDictionaries {
            let image = dict["image"] as! String
            buildingImages.append(image)
        }
        return buildingImages
    }
    
    func getMetersFromNames(names: [String], meterType: String) -> [String] {
        var meterNames = [String]()
        for dict in self.buildingsDictionaries {
            for displayName in names {
                if dict["displayName"] as! String == displayName {
                    if let meterArray = dict["meters"] as? NSArray {
                        var hasMeter = false
                        for meter in meterArray{
                            if let m = meter["displayName"] as? String {
                                if m == displayName + " - " + meterType.capitalizedString {
                                    meterNames.append(meter["systemName"] as! String)
                                    hasMeter = true
                                    break;
                                }
                            }
                        }
                        if hasMeter == false {
                            meterNames.append("")
                        }
                    }
                }
            }
        }
        return meterNames
    }
    
}
