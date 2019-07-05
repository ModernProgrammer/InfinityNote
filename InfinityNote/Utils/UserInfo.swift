//
//  UserInfo.swift
//  InfinityNote
//
//  Created by Diego Bustamante on 7/5/19.
//  Copyright © 2019 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class UserInfo {
    static let shared = UserInfo()
    
    var user : User?
    
    func getUserInfo(completion:  @escaping () -> Void) {
        let userId = Auth.auth().currentUser?.uid
        Database.database().reference().child(userId!).child("user").observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            dictionary.forEach({ (values) in
                let (_, value) = values
                self.user = User(uid: userId!, dictionary: value as! [String : Any])
            })
            completion()
        }
    }
}
