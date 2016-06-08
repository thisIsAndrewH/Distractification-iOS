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
    
    @IBOutlet weak var licenseViewArea: UIScrollView!
    
    func setupLicenses() -> Void {
        
        navigationTitle = "Licenses"
        
        let notice = Notice(name: "AFNetworking", url: "https://github.com/AFNetworking/AFNetworking", copyright: "Copyright (c) 2013-2014 AFNetworking (http://afnetworking.com/)", license: MITLicense())
        addNotice(notice)
        
        showsFullLicenseText = false
        
        Utilities().printWrapper(String(notice))
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
