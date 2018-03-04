//
//  ProfileController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/15/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    let profileImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemGreen
        return view
    }()
    
    let profileBodyContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemTan
        return view
    }()
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = paletteSystemBlue
        image.contentMode = UIViewContentMode.scaleAspectFill
        image.layer.masksToBounds = false
        return image
    }()
    
    let fullnameLabel: UILabel = {
        let label = UILabel()
        let attributedText  = NSMutableAttributedString(string: "Full Name: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    let fullName: UILabel = {
        let label = UILabel()
        let attributedText  = NSMutableAttributedString(string: "Diego Bustamante", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()

    
    let fullnameFieldLineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemGrayBlue
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    
    let emailLabel: UILabel = {
        let label = UILabel()
        let attributedText  = NSMutableAttributedString(string: "Email: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    let email: UILabel = {
        let label = UILabel()
        let attributedText  = NSMutableAttributedString(string: "diegobust4545@gmail.com", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    let emailtextFieldLineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemGrayBlue
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    
    let signoutButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText  = NSMutableAttributedString(string: "Sign Out", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: paletteSystemWhite])
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = paletteSystemGreen
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = paletteSystemTan
        setupProfileUI()
    }
    
    func setupProfileUI() {
        view.addSubview(profileImageContainer)
        view.addSubview(profileImageView)
        
        profileImageContainer.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        profileImageContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        
        let profileImageCircleSize = CGFloat(150)
        
        profileImageView.anchor(topAnchor: nil, bottomAnchor: nil, leadingAnchor: nil, trailingAnchor: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: profileImageCircleSize, height: profileImageCircleSize)
        
        profileImageView.centerXAnchor.constraint(equalTo: profileImageContainer.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: profileImageContainer.centerYAnchor).isActive = true
        
        profileImageView.layer.cornerRadius = profileImageCircleSize/2
        profileImageView.clipsToBounds = true
        
        view.addSubview(profileBodyContainer)
        profileBodyContainer.anchor(topAnchor: profileImageContainer.bottomAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        view.addSubview(fullnameLabel)
        view.addSubview(fullName)
        fullnameLabel.anchor(topAnchor: profileBodyContainer.topAnchor, bottomAnchor: nil, leadingAnchor: profileBodyContainer.leadingAnchor, trailingAnchor: nil, paddingTop: 30, paddingBottom: 30, paddingLeft: 30, paddingRight: 0, width: 0, height: 0)
        
        fullName.anchor(topAnchor: profileBodyContainer.topAnchor, bottomAnchor: nil, leadingAnchor: nil, trailingAnchor: profileBodyContainer.trailingAnchor, paddingTop: 30, paddingBottom: 30, paddingLeft: 0, paddingRight: 30, width: 0, height: 0)
        
        view.addSubview(fullnameFieldLineSeparator)
        fullnameFieldLineSeparator.anchor(topAnchor: fullName.bottomAnchor, bottomAnchor: nil, leadingAnchor: profileBodyContainer.leadingAnchor, trailingAnchor: profileBodyContainer.trailingAnchor, paddingTop: 30, paddingBottom: 30, paddingLeft: 30, paddingRight: 30, width: 0, height: 0)
        
        
        view.addSubview(emailLabel)
        view.addSubview(email)
        
        emailLabel.anchor(topAnchor: fullnameFieldLineSeparator.bottomAnchor, bottomAnchor: nil, leadingAnchor: profileBodyContainer.leadingAnchor, trailingAnchor: nil, paddingTop: 30, paddingBottom: 30, paddingLeft: 30, paddingRight: 30, width: 0, height: 0)
        
        email.anchor(topAnchor: fullnameFieldLineSeparator.bottomAnchor, bottomAnchor: nil, leadingAnchor: nil, trailingAnchor: profileBodyContainer.trailingAnchor, paddingTop: 30, paddingBottom: 30, paddingLeft: 30, paddingRight: 30, width: 0, height: 0)
        
        view.addSubview(emailtextFieldLineSeparator)
        emailtextFieldLineSeparator.anchor(topAnchor: emailLabel.bottomAnchor, bottomAnchor: nil, leadingAnchor: profileBodyContainer.leadingAnchor, trailingAnchor: profileBodyContainer.trailingAnchor, paddingTop: 30, paddingBottom: 30, paddingLeft: 30, paddingRight: 30, width: 0, height: 0)
        
        
        view.addSubview(signoutButton)
        signoutButton.anchor(topAnchor: emailtextFieldLineSeparator.bottomAnchor, bottomAnchor: nil, leadingAnchor: profileBodyContainer.leadingAnchor, trailingAnchor: profileBodyContainer.trailingAnchor, paddingTop: 30, paddingBottom: 30, paddingLeft: 30, paddingRight: 30, width: 0, height: 0)
        

    }
    
    @objc func handleLogout(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        present(alertController, animated: true, completion: nil)
        
        alertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            print("Perform Logout")
            
            do{
                try Auth.auth().signOut()
                
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            }catch let signOutErr {
                print("Failed to signout", signOutErr)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    fileprivate func fetchUserInfo() {
        //guard let userId = Auth.auth().currentUser?.uid else  { return }
        
//        Database.fetchUserWithUID(uid: userId) { (user) in
//            <#code#>
//        }
    }
}
