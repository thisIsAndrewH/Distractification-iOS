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
    func checkReminder(showAlert showAlert: Bool) -> Bool {
        var reminderStatus: Bool = false
        var notificationText: String
        let app:UIApplication = UIApplication.sharedApplication()
        let notifications = app.scheduledLocalNotifications
        
        if notifications!.isEmpty {
            notificationText = "Has no notifications"
            if showAlert == true {
                showAlertNotification(Message: notificationText)
            } else {
                Utilities().printWrapper(notificationText)
            }
        }
        else{
            notificationText = "Has notifications: " + String(notifications)
            if showAlert == true {
                showAlertNotification(Message: notificationText)
            } else {
                Utilities().printWrapper(notificationText)
            }
            reminderStatus = true
        }
        
        return reminderStatus
    }
    
    //Sets a reminder to date in the future based off of Now()
    func setReminder() -> Void {
        //no reminders already set, so set one up!
        if !checkReminder(showAlert: false){
            let reminderFireDate = NSDate().dateByAddingTimeInterval(Config.reminderTimer)
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
        if checkReminder(showAlert: false){
            let app:UIApplication = UIApplication.sharedApplication()
            for oneEvent in app.scheduledLocalNotifications! {
                let notification = oneEvent as UILocalNotification
                app.cancelLocalNotification(notification)
            }
        }
    }
    
    func showAlertNotification(Message Message: String) -> Void {
        let alertTitle = "Reminder Status"
        let notificationAlert = UIAlertController(title: alertTitle, message: Message, preferredStyle: .Alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        notificationAlert.addAction(okayAction)
        
        //find top controller to present the alert
        var topController = UIApplication.sharedApplication().keyWindow!.rootViewController! as UIViewController
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!;
        }
        
        topController.presentViewController(notificationAlert, animated:true, completion:nil)
    }

}
