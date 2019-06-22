//
//  User.swift
//  InfinityNote
//
//  Created by Diego Bustamante on 6/20/19.
//  Copyright © 2019 Diego Bustamante. All rights reserved.
//

import UIKit

struct User {
    let fullname: String
    let email: String
    //    let profileImageURL: String
    let uid:String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}

