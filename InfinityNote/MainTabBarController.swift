//
//  ViewController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/10/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupMenuBar()
        view.backgroundColor = .white
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.presentLoginController()
            }
            return
        } else {
            UserInfo.shared.getUserInfo {
                self.setUpControllers()
                self.fadeInView()
            }
        }
    }
    
    fileprivate func presentLoginController() {
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        self.present(navController, animated: true, completion: nil)
    }
    
    fileprivate func setupMenuBar() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.tintColor = paletteSystemGrayBlue
        tabBar.barTintColor  = UIColor.clear
        tabBar.backgroundColor = UIColor.clear
    }
    
    fileprivate func presentAddNoteController() {
        let addNoteController = AddNoteController()
        let navController = UINavigationController(rootViewController: addNoteController)
        present(navController, animated: true, completion: nil)
    }
    
    fileprivate func fadeInView() {
        viewControllers?.forEach({ (view) in
            view.view.fadeIn()
            tabBar.fadeIn()
        })
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            presentAddNoteController()
            return false
        }
        return true
    }
    
    func setUpControllers(){
        tabBar.alpha = 0
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "notes"), selectedImage: #imageLiteral(resourceName: "notes"), rootViewController: NoteBookController())
        
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search"), selectedImage: #imageLiteral(resourceName: "search"), rootViewController: SearchController())

        let addNoteNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "addNote"), selectedImage: #imageLiteral(resourceName: "addNote"), rootViewController:AddNoteController())

        let bookMarkController = templateNavController(unselectedImage: #imageLiteral(resourceName: "favUnselected"), selectedImage: #imageLiteral(resourceName: "favSelected"), rootViewController: BookmarkController())

        let profileController = templateNavController(unselectedImage: #imageLiteral(resourceName: "userUnselected"), selectedImage: #imageLiteral(resourceName: "userSelected"),  rootViewController: ProfileController())
        
        tabBar.tintColor = paletteSystemGreen
        tabBar.barTintColor = .clear
        
        viewControllers = [homeNavController, searchNavController, addNoteNavController, bookMarkController, profileController]
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let viewNavController = UINavigationController(rootViewController: viewController)
        viewNavController.view.alpha = 0
        if selectedImage == #imageLiteral(resourceName: "addNote") {
            let image: UIImage? = unselectedImage?.withRenderingMode(.alwaysOriginal)
             viewNavController.tabBarItem.title = title
            viewNavController.tabBarItem.image = image
            
            return viewNavController
        }

        viewNavController.tabBarItem.image = unselectedImage
        viewNavController.tabBarItem.selectedImage = selectedImage
        viewNavController.tabBarItem.title = title
        return viewNavController
    }
}

