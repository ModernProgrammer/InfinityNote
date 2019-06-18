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
        view.backgroundColor = paletteSystemWhite
        setupProfileUI()
        fetchUserInfo()
        navigationItem.title = "Profile"
    }
    
    let infinityLoader: AnimationView = {
        let lottie = AnimationView(filePath: "infinityLoaderProfile")
        lottie.play()
        lottie.contentMode = .scaleAspectFit
        lottie.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return lottie
    }()
    
    let profileImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let profileBodyContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemWhite
        return view
    }()
    
    let profileImageView: AnimationView = {
        let lottie = AnimationView(name: "photo")
        lottie.play()
        lottie.loopMode = LottieLoopMode.autoReverse
        lottie.backgroundBehavior = .pauseAndRestore
        return lottie
    }()
    
    let fullnameLabel: UILabel = {
        let label = UILabel()
        let attributedText  = NSMutableAttributedString(string: "Full Name: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    let fullName: UILabel = {
        let label = UILabel()
        let attributedText  = NSMutableAttributedString(string: "Diego Bustamante", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
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
        let attributedText  = NSMutableAttributedString(string: "Email: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    let email: UILabel = {
        let label = UILabel()
        let attributedText  = NSMutableAttributedString(string: "diegobust4545@gmail.com", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
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
        let attributedText  = NSMutableAttributedString(string: "Sign Out", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemWhite])
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = paletteSystemGreen
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return button
    }()
    
    
    
    
    func setupProfileUI() {
        setupNavBar(barTintColor: paletteSystemWhite, tintColor: paletteSystemGrayBlue, textColor: paletteSystemGrayBlue, clearNavBar: true, largeTitle: true)
        
        view.addSubview(infinityLoader)
        view.addSubview(profileBodyContainer)
        view.addSubview(signoutButton)
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
                self.email.attributedText = NSMutableAttributedString(string: userInfo.email, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
                self.fullName.attributedText = NSMutableAttributedString(string: userInfo.fullname, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
                // set profile image here
                self.user.append(userInfo)
                
            })
        }
    }
}

