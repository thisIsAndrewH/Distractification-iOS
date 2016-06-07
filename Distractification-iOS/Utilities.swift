//
//  Utilities.swift
//  Distractification-iOS
//
//  Created by Andrew Harris on 5/30/16.
//  Copyright © 2016 Andrew Harris. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
    func printWrapper(messageToPrint: String) -> Void {
        let separator = "\n================================================\n"
        
        print(separator + messageToPrint + separator)
    }

}
