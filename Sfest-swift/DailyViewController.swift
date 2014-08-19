//
//  TableViewController.swift
//  Sfest-swift
//
//  Created by Peter Zignego on 6/23/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.

import UIKit

protocol DateChangedDelegate {
    func dateChanged(stage:String, date:String)
}

class DailyViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var stageView: UIView!
    @IBOutlet var stageNameLabel: UILabel!
    @IBOutlet var dateView: UIView!
    @IBOutlet var dayOfTheWeekLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    
    var backgroundImage: UIImage?
    var returnRectangle: CGRect?
    var savedScrollPosition: CGPoint?
    var selectedIndex: NSIndexPath?
    var stageName: String?
    var stageColor: UIColor?
    var complimentaryColor: UIColor?
    var globalDate : NSDate?
    var delegate: DateChangedDelegate?
    var tableViewController: TableViewController?
    var mapView: MapView?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalDate = dateTest(NSDate.date())
        setupViews()
        gestureRecognizers()
    }
    
    override func viewDidAppear(animated: Bool) {
        let animateView = UIView(frame:CGRect(x: 0, y: 45, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height-45))
        animateView.backgroundColor = stageColor
        view.addSubview(animateView)
        UIView.animateWithDuration(0.5, delay: 0.00, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.00, options: UIViewAnimationOptions.CurveEaseOut, animations:{
            animateView.frame = CGRect(x: 0.0, y: UIScreen.mainScreen().bounds.size.height, width: UIScreen.mainScreen().bounds.size.width, height:UIScreen.mainScreen().bounds.size.height-45)
            }, completion: {
                finished in
                animateView.removeFromSuperview()
                })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func setupViews() {
        //Stage
        stageView.backgroundColor = stageColor!
        stageNameLabel.text = stageName!
        if (stageNameLabel.text == "Johnson Controls World Sound Stage") {
            stageNameLabel.font = UIFont(name: "Futura", size: 16)
        }
        //Date
        dayOfTheWeekLabel!.text = convertDateToStrings(globalDate!).dayOfTheWeek
        dateLabel!.text = convertDateToStrings(globalDate!).longDateString
        dateView.backgroundColor = complimentaryColor!
        
        //TableView Subview
        tableViewController = TableViewController(stage: stageName!, date: convertDateToStrings(globalDate!).queryDateString, complimentaryColor: complimentaryColor!)
        self.addChildViewController(tableViewController)
        self.view.addSubview(tableViewController!.view)
        tableViewController!.didMoveToParentViewController(self)
        
        //Close Button
        view.bringSubviewToFront(closeButton)
    }
    
    func gestureRecognizers() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: "pinchToClose:")
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "dateForward:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: "dateBackward:")
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(pinchGesture)
        view.addGestureRecognizer(swipeLeftGesture)
        view.addGestureRecognizer(swipeRightGesture)
    }
    
    func close() {
        if (mapView?.frame.origin.y == 45){
            hideMapView(closeButton)
        }
        else {
            let backgroundImageView:UIImageView = UIImageView(image: backgroundImage!)
            view.addSubview(backgroundImageView)
            let animateView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height))
            animateView.backgroundColor = stageColor!
            view.addSubview(animateView)
            UIView.animateWithDuration(0.5, animations: {
                animateView.frame = self.returnRectangle!
                animateView.alpha = 0.5
                }, completion: {
                    finished in
                    animateView.removeFromSuperview()
                    backgroundImageView.removeFromSuperview()
                    let stageViewController = self.navigationController.viewControllers[0] as StageViewController
                    stageViewController.savedScrollPosition = self.savedScrollPosition!
                    self.navigationController.popToRootViewControllerAnimated(false)
                })
        }
    }
    
    @IBAction func buttonToClose(sender: UIButton) {
        close()
    }
    
    func pinchToClose(sender:UIPinchGestureRecognizer) {
        close()
    }
    
    func dateTest(aDate:NSDate) -> NSDate {
        let dateComponents = NSDateComponents()
        dateComponents.calendar = NSCalendar.currentCalendar()
        dateComponents.year = 2013
        dateComponents.month = 6
        dateComponents.day = 26
        let startDate = dateComponents.date
        dateComponents.year = 2013
        dateComponents.month = 7
        dateComponents.day = 7
        let endDate = dateComponents.date
        let startDateComparisonResult = aDate.compare(startDate)
        let endDateComparisonResult = aDate.compare(endDate)
        if (startDateComparisonResult == NSComparisonResult.OrderedAscending){
            return startDate
        }
        else if (endDateComparisonResult == NSComparisonResult.OrderedDescending){
            return endDate
        }
        else {
            return aDate
        }
    }
    
    @IBAction func dateForwardButton(sender: UIButton) {
        dateForward(sender)
    }
    
    func dateForward(sender:UIButton) {
        globalDate = dateTest(globalDate!.dateByAddingTimeInterval(24*60*60))
        dayOfTheWeekLabel!.text = convertDateToStrings(globalDate!).dayOfTheWeek
        dateLabel!.text = convertDateToStrings(globalDate!).longDateString
        self.delegate = tableViewController
        delegate?.dateChanged(stageName!, date: convertDateToStrings(globalDate!).queryDateString)
    }
    
    @IBAction func dateBackwardButton(sender: UIButton) {
        dateBackward(sender)
    }
    
    func dateBackward(sender:UIButton) {
        globalDate = dateTest(globalDate!.dateByAddingTimeInterval(-24*60*60))
        dayOfTheWeekLabel!.text = convertDateToStrings(globalDate!).dayOfTheWeek
        dateLabel!.text = convertDateToStrings(globalDate!).longDateString
        self.delegate = tableViewController
        delegate?.dateChanged(stageName!, date: convertDateToStrings(globalDate!).queryDateString)
    }
    
    func convertDateToStrings(date:NSDate)-> (queryDateString:String, longDateString:String, dayOfTheWeek:String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        let queryString = dateFormatter.stringFromDate(date)
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let longString = dateFormatter.stringFromDate(date)
        dateFormatter.dateFormat = "EEEE"
        let dayString = dateFormatter.stringFromDate(date)
        return (queryString, longString, dayString)
    }
    
    @IBAction func mapViewButton(sender: UIButton) {
        if (mapView?.frame.origin.y == 45) {
            hideMapView(sender)
        }
        else {
        showMapView(sender)
        }
    }
    
    func showMapView(sender:UIButton) {
        mapView = MapView(stage: stageName!)
        self.view.addSubview(mapView!)
        view.bringSubviewToFront(closeButton)
        mapView!.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height-45)
        UIView.animateWithDuration(0.5, delay: 0.00, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.00, options: UIViewAnimationOptions.CurveEaseOut, animations:{
            self.mapView!.frame = CGRect(x: 0, y: 45, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height-45)
            }, completion: {
                finished in
            })
    }
    
    func hideMapView(sender:UIButton) {
        UIView.animateWithDuration(0.5, delay: 0.00, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.00, options: UIViewAnimationOptions.CurveEaseOut, animations:{
        self.mapView!.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height-45)
        }, completion: {
        finished in
            self.mapView?.removeFromSuperview()
            self.mapView = nil
        })
    }

    override func didReceiveMemoryWarning() {
        
    }
    
}