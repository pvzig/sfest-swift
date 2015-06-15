//
//  TableViewController.swift
//  Sfest-swift
//
//  Created by Peter Zignego on 6/27/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.

import UIKit

class ShowTableViewCell: UITableViewCell {
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var bandLabel: UILabel!
}

class TableViewController:UITableViewController, DateChangedDelegate {
    
    var data: Array<(band:String, time:String)> = []
    let db = BandDatabase.sharedInstance
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        db.open()
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = NSUserDefaults.standardUserDefaults().colorForKey("complimentaryColor")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48.00
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (data.count > 0) {
            return data.count
        }
        else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bands", forIndexPath: indexPath) as! ShowTableViewCell
        
        if (data.count > 0) {
            cell.bandLabel.text = data[indexPath.row].band
            cell.timeLabel.text = data[indexPath.row].time
        }
        else {
            cell.bandLabel.text = "Sorry, no bands playing here tonight."
            cell.timeLabel.text = ""
        }

        return cell
    }
    
    func bandsPlayingStage(stage stage:String, date:String) -> Array<(band:String, time:String)> {
        return db.bandsPlayingAtStage(stage, date:date)
    }
    
    func dateChanged(stage:String, date:String) {
        data.removeAll(keepCapacity: false)
        data = bandsPlayingStage(stage: stage, date: date)
        self.tableView.reloadData()
    }
    
}