//
//  ViewController.swift
//  Energy
//
//  Created by Simon Orlovsky on 4/30/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var items: [String] = ["Olin", "Burton", "Cassat"]
    var images: [UIImage] = [UIImage(named: "olin")!, UIImage(named: "burton")!, UIImage(named: "cassat")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = items[indexPath.row]
        cell.imageView!.image = images[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        performSegueWithIdentifier("detailSegue", sender: self)
    }
}