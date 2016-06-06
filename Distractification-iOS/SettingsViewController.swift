//
//  SettingsViewController.swift
//  Distractification-iOS
//
//  Created by Andrew Harris on 6/6/16.
//  Copyright © 2016 Andrew Harris. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let reminderToggleStatus = userDefaults.boolForKey("reminderToggleDefault")

        // Do any additional setup after loading the view.
        
        //set the toggle correctly
        if (reminderToggleStatus){
            settingsReminderToggle.setOn(reminderToggleStatus, animated: false)
            print("toggle state: " + String(reminderToggleStatus))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var settingsReminderToggle: UISwitch!
    
    @IBAction func reminderToggleSet(sender: AnyObject) {
        Utilities().printWrapper(String(settingsReminderToggle.on))
        
        if (settingsReminderToggle.on) {
            userDefaults.setBool(true, forKey: "reminderToggleDefault")
            Reminder().setReminder()
        }
        else {
            
            userDefaults.setBool(false, forKey: "reminderToggleDefault")
            Reminder().clearReminder()
        }
    }
    
    @IBAction func crashTest(sender: AnyObject) {
        //fatalError()
        //FIRCrashMessage("Crash button clicked - not an actual error.")
        //[0][1]
        
        Reminder().checkReminder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
