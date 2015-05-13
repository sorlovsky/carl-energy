//
//  DetailConsumptionViewController.swift
//  Energy
//
//  Created by Simon Orlovsky on 5/10/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

class DetailConsumptionViewController: UIViewController {
    
    var selectedBuildings = [String]()
    
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stringRepresentation = "-".join(selectedBuildings)
        titleLabel.text = stringRepresentation as String

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
