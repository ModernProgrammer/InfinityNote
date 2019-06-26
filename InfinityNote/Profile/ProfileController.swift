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
        view.backgroundColor = .clear
        return view
    }()
    
    let profileImage : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(presentPhotoLibrary), for: .touchUpInside)
        return button
        
    }()
    
    let profileBodyContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let profileImageView: AnimationView = {
        let lottie = AnimationView(name: "photo")
        lottie.play()
        lottie.loopMode = LottieLoopMode.autoReverse
        lottie.backgroundBehavior = .pauseAndRestore
        return lottie
    }()
    
    let profileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(presentPhotoLibrary), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    let userInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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
//        guard let userInfo = UserManager.shared.user else  { return }
        let attributedText = NSMutableAttributedString(string: "Diego Bustamante\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
        attributedText.append(NSMutableAttributedString(string: "diegobust4545@gmail.com", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .light), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue]))
//        self.email.attributedText = NSMutableAttributedString(string: userInfo.email, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
//        self.fullName.attributedText = NSMutableAttributedString(string: userInfo.fullname, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
        self.userInfoLabel.attributedText = attributedText
//        print("Testing: \(userInfo.email) and \(userInfo.fullname)")
        // set profile image here
    }
    
    fileprivate func setupMainStackView() {
        let stackView = UIStackView(arrangedSubviews: [profileImageContainer, profileBodyContainer])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupProfileImage() {
        profileImageContainer.addSubview(profileImageView)
        // If Image does not exist
        profileImageView.anchor(topAnchor: profileImageContainer.topAnchor, bottomAnchor: profileImageContainer.bottomAnchor, leadingAnchor: profileImageContainer.leadingAnchor, trailingAnchor: profileImageContainer.trailingAnchor, paddingTop: 30, paddingBottom: 30, paddingLeft: 30, paddingRight: 30, width: 0, height: 0)
        profileImageView.addSubview(profileImageButton)
        profileImageButton.anchor(topAnchor: profileImageView.topAnchor, bottomAnchor: profileImageView.bottomAnchor, leadingAnchor: profileImageView.leadingAnchor, trailingAnchor: profileImageView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        // Else set image as profile pic
        
//        profileImageContainer.addSubview(profileImage)
//        profileImage.anchor(topAnchor: profileImageContainer.topAnchor, bottomAnchor: profileImageContainer.bottomAnchor, leadingAnchor: profileImageContainer.leadingAnchor, trailingAnchor: profileImageContainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func setupProfileUI() {
        setupNavBar(barTintColor: paletteSystemWhite, tintColor: paletteSystemGrayBlue, textColor: paletteSystemGrayBlue, clearNavBar: true, largeTitle: true)
        navigationItem.title = "Profile"
        setupMainStackView()
        setupProfileImage()
        
        let stackView = UIStackView(arrangedSubviews: [UIView(),userInfoLabel, signoutButton, UIView()])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 10
        profileBodyContainer.addSubview(stackView)
        stackView.anchor(topAnchor: profileBodyContainer.topAnchor, bottomAnchor: profileBodyContainer.bottomAnchor, leadingAnchor: profileBodyContainer.leadingAnchor, trailingAnchor: profileBodyContainer.trailingAnchor, paddingTop: 30, paddingBottom: 30, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
        setUserInfo()
        
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
    
    func updateUser(uid: String, imageName: String) {
        let dictionaryValues = ["profileImageUID":imageName]
        let values = [uid:dictionaryValues]
        Database.database().reference().child(uid).updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Oops, looks like something went wrong: ", error)
                return
            }
            print("Successful Upload")
        }

    }
    
    func setSelectImage(image: UIImage) {
        // Upload to Firebase
        let imageName = NSUUID().uuidString
        let uid = String(Auth.auth().currentUser!.uid)
        guard let data = image.pngData() else { return }
        let storageRef = Storage.storage().reference().child(uid).child("\(imageName).png")
        storageRef.putData(data, metadata: nil) { (meta, error) in
            if error != nil {
                print(error as Any)
                return
            }
            self.updateUser(uid: uid, imageName: imageName)
            print("Update User")
            
        }
        
        
        // Set image as profile Pic
        profileImageContainer.addSubview(profileImage)
        profileImage.anchor(topAnchor: profileImageContainer.topAnchor, bottomAnchor: profileImageContainer.bottomAnchor, leadingAnchor: profileImageContainer.leadingAnchor, trailingAnchor: profileImageContainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        profileImage.setImage(image, for: .normal)
        profileImage.contentHorizontalAlignment = .center
        profileImage.contentVerticalAlignment = .center
        profileImage.imageView?.contentMode = .scaleAspectFill
    }
}

