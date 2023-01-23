//
//  UIApplication+VersionNumbers.swift
//  
//
//  Created by Davis Allie on 12/6/2022.
//

import UIKit

public extension UIApplication {
    
    var versionNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
    
}
