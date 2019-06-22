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

class ProfileController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = paletteSystemWhite
        setUserInfo()
        setupProfileUI()
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
        view.backgroundColor = paletteSystemBlue
        return view
    }()
    
    let profileBodyContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemGreen
        return view
    }()
    
    let profileImageView: AnimatedButton = {
        let lottie = AnimationView(name: "photo")
        lottie.play()
        lottie.loopMode = LottieLoopMode.autoReverse
        lottie.backgroundBehavior = .pauseAndRestore
        let button = AnimatedButton(animation: lottie.animation!)
        button.addTarget(self, action: #selector(presentPhotoLibrary), for: .touchUpInside)
        return button
    }()
    
    let profileImageButton: AnimatedButton = {
        let lottie = AnimationView(name: "photo")
        lottie.play()
        lottie.loopMode = LottieLoopMode.autoReverse
        lottie.backgroundBehavior = .pauseAndRestore
        let button = AnimatedButton(animation: lottie.animation!)
        return button
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
}

extension ProfileController {
    func setUserInfo() {
        guard let userInfo = UserManager.shared.user else  { return }
        self.email.attributedText = NSMutableAttributedString(string: userInfo.email, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
        self.fullName.attributedText = NSMutableAttributedString(string: userInfo.fullname, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
        print("Testing: \(userInfo.email) and \(userInfo.fullname)")
        // set profile image here
    }
    
    func setupProfileUI() {
        setupNavBar(barTintColor: paletteSystemWhite, tintColor: paletteSystemGrayBlue, textColor: paletteSystemGrayBlue, clearNavBar: true, largeTitle: true)
        navigationItem.title = "Profile"
        
        let stackView = UIStackView(arrangedSubviews: [profileImageContainer, profileBodyContainer])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
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
                self.present(navController, animated: true, completion: {
                    let mainTabBarController = UIApplication.mainTabBarController()
                    mainTabBarController?.selectedIndex = 0
                })
            } catch let signOutErr {
                print("Failed to signout", signOutErr)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
}

extension ProfileController {
    @objc func presentPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = paletteSystemGreen
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            setSelectImage(image: editImage)
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            setSelectImage(image: originalImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setSelectImage(image: UIImage) {
//        selectImage.setImage(image, for: .normal)
//        selectImage.contentHorizontalAlignment = .center
//        selectImage.contentVerticalAlignment = .center
//        selectImage.imageView?.contentMode = .scaleAspectFill
    }
}

