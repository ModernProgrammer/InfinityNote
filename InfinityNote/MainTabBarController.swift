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
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        setUpControllers()
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {
            let addNoteController = AddNoteController()
            let navController = UINavigationController(rootViewController: addNoteController)
            present(navController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    func setUpControllers(){
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "notes"), selectedImage: #imageLiteral(resourceName: "notes"), title: "Home", rootViewController: NoteBookController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search"), selectedImage: #imageLiteral(resourceName: "search"), title: "Search",rootViewController: SearchController(collectionViewLayout: UICollectionViewFlowLayout()))

        let addNoteNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "addNote"), selectedImage: #imageLiteral(resourceName: "addNote"), title: "Add Note", rootViewController:AddNoteController())

        let bookMarkController = templateNavController(unselectedImage: #imageLiteral(resourceName: "favUnselected"), selectedImage: #imageLiteral(resourceName: "favSelected"), title: "Bookmarks", rootViewController: BookmarkController(collectionViewLayout: UICollectionViewFlowLayout()))

        let profileController = templateNavController(unselectedImage: #imageLiteral(resourceName: "userUnselected"), selectedImage: #imageLiteral(resourceName: "userSelected"), title: "Profile", rootViewController: ProfileController())
        
        tabBar.tintColor = paletteSystemWhite
        tabBar.barTintColor = paletteSystemGrayBlue
        
        viewControllers = [homeNavController, searchNavController, addNoteNavController, bookMarkController, profileController]
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage?, selectedImage: UIImage?, title: String?,
                                           rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let viewNavController = UINavigationController(rootViewController: viewController)
        
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

