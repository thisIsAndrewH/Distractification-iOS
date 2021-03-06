//
//  ViewController.swift
//  Distractification-iOS
//
//  Created by Andrew Harris on 5/20/16.
//  Copyright © 2016 Andrew Harris. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import FirebaseInstanceID
let userDefaults = NSUserDefaults.standardUserDefaults()




class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        checkToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var weekCount: UILabel!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var todayCount: UILabel!
    @IBOutlet weak var dateDisplay: UILabel!
    
    @IBAction func runButton(sender: AnyObject) {
        var queryDateToday = getQueryDate(1) // query today
        var queryURLToday = createURL(queryDateToday)
        data_request(queryURLToday, isDay: true)
        
        queryDateToday = getQueryDate(7) // query today
        queryURLToday = createURL(queryDateToday)
        data_request(queryURLToday, isDay: false)
        dateDisplay.text = getCurrentTime()
        
        //Tests
        Utilities().printWrapper("Time: " + dateDisplay.text!)
        Utilities().printWrapper("URL param: " + String(queryURLToday))
        Utilities().printWrapper(String(FIRInstanceID.instanceID().token()))
    }
    
    func getCurrentTime() -> String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        
        return dateFormatter.stringFromDate(date)
    }
    
    //  Returns the date string for the API call
    func getQueryDate(daysBehind: Int) -> String {
        let userCalendar = NSCalendar.currentCalendar()
        let periodComponents = NSDateComponents()
        periodComponents.day = -daysBehind
        
        let searchDate = userCalendar.dateByAddingComponents(periodComponents, toDate: NSDate(), options: [])!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateReturn = dateFormatter.stringFromDate(searchDate)
        
        return dateReturn
    }
    
    func checkToken() {
        //check config file for token
        let token = userDefaults.stringForKey("APIKeyStoredSetting")
        
        if token == "" {
            runButton.enabled = false
            
            let title = "Configuration Error"
            let message = "You must supply the Slack token in Config.swift to execute query."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            alert.addAction(dismissAction)
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            runButton.enabled = true
        }
    }
    
    func createURL(dateAfter: String) -> NSURL {
        //null check for token appears in viewDidAppear -> CheckToken()
        let token = Config.slackApiToken
        let endpoint = "https://slack.com/api/search.messages?token="
            + token
            + "&query=from:me%20after:"
            + dateAfter
            + "&pretty=1"
        let request = NSURL(string: endpoint)!
        
        return request
    }
    
    func getMessageCount(data: String, isDay: Bool) -> Int {
        var messageCount:Int = 0
        let isDayResponse = isDay
        if let dataFromString = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let jsonData = JSON(data: dataFromString)
            let totalMessagesSent = jsonData["messages","pagination","total_count"].stringValue
            
            messageCount = Int(totalMessagesSent)!
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            if isDayResponse == true {
                self.todayCount.text = String(messageCount)
                Utilities().printWrapper("testing set today count func: " + String(messageCount))
                
                FIRAnalytics.logEventWithName("dailyCount", parameters: [
                    kFIRParameterValue: messageCount
                    ])
            }
            else {
                self.weekCount.text = String(messageCount)
                Utilities().printWrapper("testing set week count func: " + String(messageCount))
                
                FIRAnalytics.logEventWithName("weeklyCount", parameters: [
                    kFIRParameterValue: messageCount
                    ])
            }
        }
        
        //Checks if you're over the limit
        if isDayResponse == true && Int(messageCount) > Config.thresholdLimit {
            showMessageCountAlert(messageCount)
        }
        
        return messageCount
    }
    
    //isDay determines if we're updating the "day" or "week" field in the UI
    func data_request(url_to_request: NSURL, isDay: Bool) -> Void {
        let url:NSURL = url_to_request
        let isDayResponse = isDay
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = session.dataTaskWithRequest(request) {
            [weak self] (let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                print("error")
                return
            }
            
            guard let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) else {
                print("error")
                return
            }
            
            self?.getMessageCount(dataString as String, isDay: isDayResponse)
        }
        task.resume()
    }

    func showMessageCountAlert(count: Int) -> Void {
        let title = "Message Warning"
        let message = "You have sent " + String(count) + " messages today. Consider chilling out."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        alert.addAction(okayAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }

}