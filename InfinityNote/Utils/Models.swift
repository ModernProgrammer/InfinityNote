//
//  Models.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/12/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import Foundation
import UIKit

// App Palette Coolers
var paletteSystemWhite = UIColor.rgb(red: 253, green: 255, blue: 252)
var paletteSystemBlue = UIColor.rgb(red: 54, green: 75, blue: 110)
var paletteSystemGreen = UIColor.rgb(red: 38, green: 196, blue: 133)
var paletteSystemGrayBlue = UIColor.rgb(red: 72, green: 77, blue: 109)
var paletteSystemTan = UIColor.rgb(red: 241, green: 247, blue: 237)

// Locks view orientation
struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}

struct User {
    let fullname: String
    let email: String
    let profileImageURL: String
    let uid:String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.fullname = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}

struct Notebook {
    let notebookTitle: String
    init(dictionary: [String: Any], notebookTitle: String){
        self.notebookTitle = notebookTitle
    }
}

struct Note {
    let title: String
    let date: String
    let body: String
    
    init(dictionary: [String: Any], noteTitle: String){
        self.title = noteTitle
        self.date =  dictionary["date"] as? String ?? ""
        self.body =  dictionary["body"] as? String ?? ""
    }
}
