//
//  ProductionViewController.swift
//  Energy
//
//  Created by Simon Orlovsky on 5/8/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

class ProductionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var items: [String] = ["Burton", "Cassat", "Davis"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
}