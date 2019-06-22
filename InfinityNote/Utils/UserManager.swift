//
//  UserManager.swift
//  InfinityNote
//
//  Created by Diego Bustamante on 6/20/19.
//  Copyright © 2019 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

struct UserManager {
    static var shared = UserManager()
    var user : User?
    var isUserLoggedIn : Bool = false
}

extension UserManager {
    func setUserInfo(userId: String,  completion: @escaping () -> ()) {
        Database.database().reference().child(userId).child("user").observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            dictionary.forEach({ (values) in
                let (_, value) = values
                UserManager.shared.user = User(uid: userId, dictionary: value as! [String : Any])
                UserManager.shared.isUserLoggedIn = true
            })
            completion()
        }
    }
}
