//
//  ViewController.swift
//  Sfest-swift
//
//  Created by Peter Zignego on 6/23/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.

import UIKit

extension NSUserDefaults {
    
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = dataForKey(key) {
            color = NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedDataWithRootObject(color)
        }
        setObject(colorData, forKey: key)
    }
    
}

class StageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var stageNameLabel: UILabel!
}

class StageViewController: UICollectionViewController {
    
    var savedScrollPosition = CGPoint(x: 0, y: 0)
    let stagesArray = ["BMO Harris Pavilion", "Briggs & Stratton Big Backyard", "Harley-Davidson Roadhouse", "Johnson Controls World Sound Stage", "Marcus Amphitheater", "Miller Lite Oasis", "U.S. Cellular Connection Stage", "Uline Warehouse"]
    let colorsArray = [UIColor(red: 255.00/255.00, green: 85.00/255.00, blue: 55.00/255.00, alpha: 1.0), UIColor(red: 255.00/255.00, green: 103.00/255.00, blue: 77.00/255.00, alpha: 1.0), UIColor(red: 255.00/255.00, green: 200.00/255.00, blue: 5.00/255.00, alpha: 1.0), UIColor(red: 255.00/255.00, green: 217.00/255.00, blue: 1.00/255.00, alpha: 1.0),  UIColor(red: 0.00/255.00, green: 212.00/255.00, blue: 251.00/255.00, alpha: 1.0), UIColor(red: 0.00/255.00, green: 189.00/255.00, blue: 235.00/255.00, alpha: 1.0),  UIColor(red: 3.00/255.00, green: 237.00/255.00, blue: 152.00/255.00, alpha: 1.0), UIColor(red: 0.00/255.00, green: 251.00/255.00, blue: 174.00/255.00, alpha: 1.0)]
    
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
        return stagesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let halfWidth = UIScreen.mainScreen().bounds.size.width / 2
        return CGSize(width: halfWidth, height: halfWidth)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("stage", forIndexPath: indexPath) as! StageCollectionViewCell
        cell.backgroundColor = colorsArray[indexPath.row]
        cell.stageNameLabel.text = stagesArray[indexPath.row]
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! StageCollectionViewCell
        let rect = cell.frame
        let animateView = UIView(frame: CGRect(x: rect.origin.x, y: rect.origin.y - collectionView.contentOffset.y, width: rect.size.width, height: rect.size.height))
        animateView.backgroundColor = colorsArray[indexPath.row]

        let animateLabel = configureAnimateLabelWithFrame(cell.stageNameLabel.frame)
        animateLabel.text = stagesArray[indexPath.row]
        animateView.addSubview(animateLabel)
        self.view.addSubview(animateView)
        
        UIView.animateWithDuration(0.5, animations: {
            animateView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height)
            animateView.subviews[0].frame = CGRect(x: 0.0, y: 5.0, width: UIScreen.mainScreen().bounds.size.width, height:45.0)
            }, completion: {
                finished in
                animateView.removeFromSuperview()
                self.dailyViewTransitionWithStageIndex(indexPath)
            })
    }
    
    func dailyViewTransitionWithStageIndex(index: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dailyViewController = storyboard.instantiateViewControllerWithIdentifier("dvc") as! DailyViewController
        
        dailyViewController.backgroundImage = self.backgroundImage()
        dailyViewController.selectedIndex = index
        dailyViewController.savedScrollPosition = collectionView!.contentOffset
        dailyViewController.stageName = stagesArray[index.row]
        dailyViewController.stageColor = colorsArray[index.row]
        
        let rect = collectionView!.cellForItemAtIndexPath(index)!.frame
        dailyViewController.returnRectangle = CGRect(x: rect.origin.x, y: rect.origin.y - collectionView!.contentOffset.y, width: rect.size.width, height: rect.size.height)
        complimentaryColor(index)
        self.navigationController!.pushViewController(dailyViewController, animated: false)
    }
    
    func configureAnimateLabelWithFrame(frame: CGRect) -> UILabel {
        let animateLabel = UILabel(frame: frame)
        animateLabel.font = UIFont(name: "Futura", size: 19)
        animateLabel.textColor = UIColor.whiteColor()
        animateLabel.textAlignment = NSTextAlignment.Center
        return animateLabel
    }
    
    func complimentaryColor(index:NSIndexPath) {
        var i = 0
        switch(index.row){
        case 0, 2, 4, 6:
            i = 1
        default:
            i = -1
        }
        
        NSUserDefaults.standardUserDefaults().setColor(colorsArray[index.row+i], forKey: "complimentaryColor")
        NSUserDefaults.standardUserDefaults().synchronize()
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
