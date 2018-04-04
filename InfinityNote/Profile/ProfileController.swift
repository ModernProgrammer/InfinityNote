//
//  ProfileController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/15/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class ProfileController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = paletteSystemTan
        setupProfileUI()
        fetchUserInfo()
        navigationItem.title = "Profile"
    }
    
    let infinityLoader: LOTAnimationView = {
        let lottie = LOTAnimationView(filePath: "infinityLoaderProfile")
        lottie.play()
        lottie.loopAnimation = true
        lottie.contentMode = .scaleAspectFit
        lottie.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return lottie
    }()
    
    let profileImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemBlue
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
        view.backgroundColor = paletteSystemLineSeparatorColor
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
        view.backgroundColor = paletteSystemLineSeparatorColor
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
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return button
    }()
    
    
    
    
    func setupProfileUI() {
        view.addSubview(profileImageContainer)
        view.addSubview(infinityLoader)
        view.addSubview(profileBodyContainer)
        view.addSubview(signoutButton)

        
        profileImageContainer.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: nil, leadingAnchor:   view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 200)
        
        infinityLoader.anchor(topAnchor: profileImageContainer.topAnchor, bottomAnchor: profileImageContainer.bottomAnchor, leadingAnchor: profileImageContainer.leadingAnchor, trailingAnchor: profileImageContainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 200)
        
        profileBodyContainer.anchor(topAnchor: profileImageContainer.bottomAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        let stackViewFullName = UIStackView(arrangedSubviews: [fullnameLabel,fullName])
        stackViewFullName.distribution = .equalCentering
        view.addSubview(stackViewFullName)
        
        let stackViewEmail = UIStackView(arrangedSubviews: [emailLabel,email])
        stackViewEmail.distribution = .equalCentering
        
        
        let stackViewMain = UIStackView(arrangedSubviews: [stackViewFullName,fullnameFieldLineSeparator,stackViewEmail, emailtextFieldLineSeparator,signoutButton])
        
        view.addSubview(stackViewMain)
        stackViewMain.axis = .vertical
        stackViewMain.distribution = .fill
        stackViewMain.spacing = 20
        stackViewMain.anchor(topAnchor: profileBodyContainer.safeAreaLayoutGuide.topAnchor, bottomAnchor: nil, leadingAnchor: profileBodyContainer.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: profileBodyContainer.safeAreaLayoutGuide.trailingAnchor, paddingTop: 20, paddingBottom: 8, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
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
    
    var user = [User]()
    fileprivate func fetchUserInfo() {
        guard let userId = Auth.auth().currentUser?.uid else  { return }

        Database.database().reference().child(userId).child("user").observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            dictionary.forEach({ (key,value) in
            
                let userInfo = User(uid: userId, dictionary: value as! [String : Any])
                self.email.attributedText = NSMutableAttributedString(string: userInfo.email, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
                self.fullName.attributedText = NSMutableAttributedString(string: userInfo.fullname, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
                // set profile image here
                
                self.user.append(userInfo)
                
            })
        }
        
    }
}

