//
//  SettingsViewController.swift
//  Distractification-iOS
//
//  Created by Andrew Harris on 6/6/16.
//  Copyright © 2016 Andrew Harris. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
let reminderToggleStatus = userDefaults.boolForKey("reminderToggleDefault")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set the toggle correctly
        if (reminderToggleStatus){
            settingsReminderToggle.setOn(reminderToggleStatus, animated: false)
            Utilities().printWrapper("toggle state: " + String(reminderToggleStatus))
        }
        
        //set API Key
        let apiKeyStoredSetting = userDefaults.stringForKey("APIKeyStoredSetting")
        Utilities().printWrapper("API Key Stored: " + (apiKeyStoredSetting ?? ""))
        
        if apiKeyStoredSetting != "" {
            apiKey.text = userDefaults.stringForKey("APIKeyStoredSetting")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var apiKey: UITextField!
    
    @IBOutlet weak var settingsReminderToggle: UISwitch!
    
    
    @IBAction func reminderToggleSet(sender: AnyObject) {
        if (settingsReminderToggle.on) {
            userDefaults.setBool(true, forKey: "reminderToggleDefault")
            Reminder().setReminder()
        }
        else {
            userDefaults.setBool(false, forKey: "reminderToggleDefault")
            Reminder().clearReminder()
        }
    }
    
    @IBAction func test(sender: AnyObject) {
        //fatalError()
        //FIRCrashMessage("Crash button clicked - not an actual error.")
        //[0][1]
        
        Reminder().checkReminder(showAlert: true)
        
    }

    @IBAction func apiKeySet(sender: AnyObject) {
        userDefaults.setValue(apiKey.text, forKey: "APIKeyStoredSetting")
        self.view.endEditing(true)
        
        Utilities().printWrapper("New api key " + (apiKey.text ?? ""))
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
