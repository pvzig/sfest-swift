//
//  TableViewController.swift
//  Sfest-swift
//
//  Created by Peter Zignego on 6/27/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.

import UIKit

class TableViewController:UITableViewController, DateChangedDelegate {
        
    var data:Array<(band:String, time:String)> = []
    let db = BandDatabase.sharedInstance

    convenience init(stage:String, date:String, complimentaryColor:UIColor) {
        self.init(style:UITableViewStyle.Plain)
        edgesForExtendedLayout = UIRectEdge.None
        view.frame = CGRect(x: 0, y: 90, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height-90)
        tableView.separatorColor = complimentaryColor
        db.open()
        data = bandsPlayingStage(stage: stage, date: date)
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
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
        let cell = UITableViewCell()
        var bandLabel = UILabel(frame: CGRect(x: 6, y: 11, width: 220, height: 26))
        var timeLabel = UILabel(frame: CGRect(x: 235, y: 11, width: 80, height: 26))
        
        bandLabel.font = UIFont(name: "Futura", size: 18.0)
        bandLabel.adjustsFontSizeToFitWidth = true
        bandLabel.numberOfLines = 0
        timeLabel.font = UIFont(name: "Futura", size: 18.0)
        timeLabel.textAlignment = NSTextAlignment.Right
        
        cell.addSubview(timeLabel)
        cell.addSubview(bandLabel)
        
        if (data.count > 0) {
        bandLabel.text = data[indexPath.row].band
        timeLabel.text = data[indexPath.row].time
        }
        
        if (data.count == 0) {
            bandLabel.text = "Sorry, no bands playing here tonight."
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