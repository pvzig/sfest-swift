//
//  ViewController.swift
//  Sfest-swift
//
//  Created by Peter Zignego on 6/23/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.

import UIKit

class StageViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var savedScrollPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.None
    }
    
    override func viewDidAppear(animated: Bool) {
        collectionView?.contentOffset = savedScrollPosition
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
            return UIStatusBarStyle.LightContent
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("stage", forIndexPath: indexPath) as! UICollectionViewCell
        let stageLabel = cell.viewWithTag(1) as! UILabel
        stageLabel.text = stageTupleAtIndex(indexPath).stageName
        cell.backgroundColor = stageTupleAtIndex(indexPath).color
        cell.addSubview(stageLabel)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let rect = collectionView.cellForItemAtIndexPath(indexPath)!.frame
        let animateView = UIView(frame: CGRect(x: rect.origin.x, y: rect.origin.y - collectionView.contentOffset.y, width: rect.size.width, height: rect.size.height))
        animateView.backgroundColor = stageTupleAtIndex(indexPath).color
        let animateLabel = UILabel(frame: CGRect(x: 0.0, y:0.0, width: 320, height:160))
        animateLabel.text = stageTupleAtIndex(indexPath).stageName
        animateLabel.font = UIFont(name: "Futura", size: 19)
        if (animateLabel.text == "Johnson Controls World Sound Stage") {
           animateLabel.font = UIFont(name: "Futura", size: 16)
        }
        animateLabel.textColor = UIColor.whiteColor()
        animateLabel.textAlignment = NSTextAlignment.Center
        animateView.addSubview(animateLabel)
        self.view.addSubview(animateView)

        UIView.animateWithDuration(0.5, animations: {
            animateView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height)
            animateLabel.frame = CGRect(x: 20, y: 15, width: 280, height: 26)
            }, completion: {
                finished in
                animateView.removeFromSuperview()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let dailyViewController = storyboard.instantiateViewControllerWithIdentifier("dvc") as! DailyViewController
                dailyViewController.backgroundImage = self.backgroundImage()
                dailyViewController.selectedIndex = indexPath
                dailyViewController.savedScrollPosition = collectionView.contentOffset
                let rect = collectionView.cellForItemAtIndexPath(indexPath)!.frame
                dailyViewController.returnRectangle = CGRect(x: rect.origin.x, y: rect.origin.y - collectionView.contentOffset.y, width: rect.size.width, height: rect.size.height)
                dailyViewController.stageName = animateLabel.text
                dailyViewController.stageColor = animateView.backgroundColor
                dailyViewController.complimentaryColor = self.complimentaryColor(indexPath)
                self.navigationController!.pushViewController(dailyViewController, animated: false)
            })
    }
    
    func stageTupleAtIndex(index:NSIndexPath) -> (stageName:String, color:UIColor) {
        let stage1 = ("BMO Harris Pavilion", UIColor(red: 255.00/255.00, green: 85.00/255.00, blue: 55.00/255.00, alpha: 1.0))
        let stage2 = ("Briggs & Stratton Big Backyard", UIColor(red: 255.00/255.00, green: 103.00/255.00, blue: 77.00/255.00, alpha: 1.0))
        let stage3 = ("Harley-Davidson Roadhouse", UIColor(red: 255.00/255.00, green: 200.00/255.00, blue: 5.00/255.00, alpha: 1.0))
        let stage4 = ("Johnson Controls World Sound Stage", UIColor(red: 255.00/255.00, green: 217.00/255.00, blue: 1.00/255.00, alpha: 1.0))
        let stage5 = ("Marcus Amphitheater", UIColor(red: 0.00/255.00, green: 212.00/255.00, blue: 251.00/255.00, alpha: 1.0))
        let stage6 = ("Miller Lite Oasis", UIColor(red: 0.00/255.00, green: 189.00/255.00, blue: 235.00/255.00, alpha: 1.0))
        let stage7 = ("U.S. Cellular Connection Stage", UIColor(red: 3.00/255.00, green: 237.00/255.00, blue: 152.00/255.00, alpha: 1.0))
        let stage8 = ("Uline Warehouse", UIColor(red: 0.00/255.00, green: 251.00/255.00, blue: 174.00/255.00, alpha: 1.0))
        let stageArray = [stage1, stage2, stage3, stage4, stage5, stage6, stage7, stage8]
        return stageArray[index.row]
    }
    
    func complimentaryColor(index:NSIndexPath) -> UIColor {
        var i = 0
        switch(index.row){
        case 0, 2, 4, 6:
            i = 1
        default:
            i = -1
        }
        let complimentaryIndex = NSIndexPath(forRow: index.row+i, inSection: index.section)
        return stageTupleAtIndex(complimentaryIndex).color
    }
    
    func backgroundImage() -> UIImage {
        let size = UIScreen.mainScreen().bounds.size
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

