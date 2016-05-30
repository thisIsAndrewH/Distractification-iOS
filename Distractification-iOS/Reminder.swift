//
//  Reminder.swift
//  Distractification-iOS
//
//  Created by Andrew Harris on 5/26/16.
//  Copyright © 2016 Andrew Harris. All rights reserved.
//

import UIKit

class Reminder: NSObject {
    //checks to see if there's a reminder already set
    func checkReminder() -> Bool {
        var reminderStatus: Bool = false
        
        let app:UIApplication = UIApplication.sharedApplication()
        let notifcations = app.scheduledLocalNotifications
        
        if notifcations!.isEmpty {
            Utilities().printWrapper("Has no notifications")
        }
        else{
            Utilities().printWrapper("Has notifications: " + String(notifcations))
            reminderStatus = true
        }
        
        return reminderStatus
    }
    
    //Sets a reminder to date in the future based off of Now()
    func setReminder() -> Void {
        //no reminders already set, so set one up!
        if !checkReminder(){
            //TODO: set repeat for each day
            let reminderFireDate = NSDate().dateByAddingTimeInterval(30)
            
            let reminderNotification = UILocalNotification()
            reminderNotification.alertBody = "It's been a while since you've last checked in. Would you like to now?"
            reminderNotification.alertTitle = "Slack check-in"
            reminderNotification.hasAction = true
            reminderNotification.fireDate = reminderFireDate
            UIApplication.sharedApplication().scheduleLocalNotification(reminderNotification)
            
        }
        
    }
    
    func clearReminder() -> Void {
        //Reminder exists, so delete it
        if checkReminder(){
            let app:UIApplication = UIApplication.sharedApplication()
            for oneEvent in app.scheduledLocalNotifications! {
                let notification = oneEvent as UILocalNotification
                app.cancelLocalNotification(notification)
            }
        }
    }

}
