//
//  LicenseViewController.swift
//  Distractification-iOS
//
//  Created by Andrew Harris on 6/8/16.
//  Copyright © 2016 Andrew Harris. All rights reserved.
//

import UIKit
import LicensesKit

class LicenseViewController: LicensesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLicenses()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupLicenses() -> Void {
        showsFullLicenseText = false
        let appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
        
        pageHeader = appName + " made possible by:"
        
        
        
        let iconNotice = Notice(name: "\"Doodle\" icon created by Kyle Tezak, from the Noun Project", url: "https://thenounproject.com/term/doodle/197599/", copyright: "\"Doodle\" icon created by Kyle Tezak, from the Noun Project", license: CreativeCommonsAttributionNoDerivs30Unported())
        addNotice(iconNotice)
        
        let SwiftyJSONNotice = Notice(name: "SwiftyJson", url: "https://github.com/SwiftyJSON/SwiftyJSON", copyright: "SwiftyJSON", license: MITLicense())
        addNotice(SwiftyJSONNotice)
        
        let licenseKitNotice = Notice(name: "LicenseKit", url: "https://github.com/mattwyskiel/LicensesKit", copyright: "Copyright 2015 Matthew Wyskiel. All rights reserved.", license: ApacheSoftwareLicense20())
        addNotice(licenseKitNotice)
        
        let firebaseNotice = Notice(name: "Firebase", url: "https://firebase.google.com/", copyright: "Google 2016", license: CreativeCommonsAttributionNoDerivs30Unported())
        addNotice(firebaseNotice)
        
        
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
