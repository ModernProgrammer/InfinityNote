//
//  SignupController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/14/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class SignupController: UIViewController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUserInterface()
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    

    


}
