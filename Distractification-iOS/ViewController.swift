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
    var reminderToggleValue:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let reminderToggleStatus = userDefaults.boolForKey("reminderToggleDefault")
        // Do any additional setup after loading the view, typically from a nib.
        if (reminderToggleStatus){
            reminderToggle.setOn(reminderToggleStatus, animated: false)
            print("toggle state: " + String(reminderToggleStatus))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var weekCount: UILabel!
    
    @IBOutlet weak var todayCount: UILabel!
    @IBOutlet weak var dateDisplay: UILabel!
    @IBOutlet weak var reminderToggle: UISwitch!
    
    @IBAction func reminderToggleSet(sender: AnyObject) {
        if (reminderToggle.on) {
            reminderToggleValue = true
            userDefaults.setBool(true, forKey: "reminderToggleDefault")
            setReminder()
            
        }
        else {
            reminderToggleValue = false
            userDefaults.setBool(false, forKey: "reminderToggleDefault")
            clearReminder()
            
        }
        print("Reminder value: " + String(reminderToggleValue))
    }
    
    @IBAction func crashTest(sender: AnyObject) {
        //fatalError()
        FIRCrashMessage("Crash button clicked - not an actual error.")
        [0][1]
        
    }
    
    @IBAction func runButton(sender: AnyObject) {
        var queryDateToday = getQueryDate(1) // query today
        var queryURLToday = createURL(queryDateToday)
        data_request(queryURLToday, isDay: true)
        
        queryDateToday = getQueryDate(7) // query today
        queryURLToday = createURL(queryDateToday)
        data_request(queryURLToday, isDay: false)
        dateDisplay.text = getCurrentTime()
        //dateDisplay.stringValue = getCurrentTime()
        
        //Tests
        print("Time: " + dateDisplay.text!)
        print("URL param: " + String(queryURLToday))
        print(FIRInstanceID.instanceID().token())
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
    
    func createURL(dateAfter: String) -> NSURL {
        let token = Config.slackApiToken
        
        if token == "" {
            //TODO: Show notification alert instead of crashing the app
            print("You must supply the Slack token in Config.swift to execute query.")
            exit(0)
        }
        
        let endpoint = "https://slack.com/api/search.messages?token="
            + token
            + "&query=from:me%20after:"
            + dateAfter
            + "&pretty=1"
        let request = NSURL(string: endpoint)!
        
        return request
    }
    
    func getMessageCount(data: String, isDay: Bool) -> String {
        var messageCount = ""
        let isDayResponse = isDay
        if let dataFromString = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let jsonData = JSON(data: dataFromString)
            let totalMessagesSent = jsonData["messages","pagination","total_count"].stringValue
            
            //print("Total messages sent: " + totalMessagesSent)
            messageCount = totalMessagesSent
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            if isDayResponse == true {
                self.todayCount.text = messageCount
                print("testing set today count func: " + messageCount)
                
                FIRAnalytics.logEventWithName("dailyCount", parameters: [
                    kFIRParameterValue: messageCount
                    ])
            }
            else {
                self.weekCount.text = messageCount
                print("testing set week count func: " + messageCount)
                
                FIRAnalytics.logEventWithName("weeklyCount", parameters: [
                    kFIRParameterValue: messageCount
                    ])
            }
        }
        
        //Checks if you're over the limit
        if isDayResponse == true && Int(messageCount) > Config.thresholdLimit {
            //TODO: resolve notifications for iOS
            showNotification(messageCount)
        }
        
        return messageCount
    }
    
    //isDay determines if we're updating the "day" or "week" field in the UI
    func data_request(url_to_request: NSURL, isDay: Bool)
    {
        let url:NSURL = url_to_request
        let isDayResponse = isDay
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = session.dataTaskWithRequest(request) {
            [weak self] (let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            guard let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) else {
                print("error")
                return
            }
            
            self?.getMessageCount(dataString as String, isDay: isDayResponse)
            //print(dataString)
        }
        task.resume()
    }
    

    func showNotification(count: String) -> Void {
        
        let localNotification = UILocalNotification()
        localNotification.alertBody = "You have sent a lot of messages in the last hour (" + count + "). Chill out."
        localNotification.alertTitle = "Message Warning"
        localNotification.hasAction = false
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    //checks to see if there's a reminder already set
    func checkReminder() -> Bool {
        let reminderStatus: Bool = false
        //CODE
        
        return reminderStatus
    }
    
    //Sets a reminder to date in the future based off of Now()
    func setReminder() -> Void {
        let reminderFireDate = NSDate().dateByAddingTimeInterval(22)
        
        let reminderNotification = UILocalNotification()
        reminderNotification.alertBody = "It's been a while since you've last checked in. Would you like to now?"
        reminderNotification.alertTitle = "Slack check-in"
        reminderNotification.hasAction = true
        reminderNotification.alertAction = "Open me.."
        reminderNotification.fireDate = reminderFireDate
        UIApplication.sharedApplication().scheduleLocalNotification(reminderNotification)
    }
    
    func clearReminder() -> Void {
        if checkReminder(){
            //Reminder exists, so delete it
        }
    }
    
    func updateReminder() -> Void {
        if checkReminder(){
            clearReminder()
            setReminder()
        }
    }

}

