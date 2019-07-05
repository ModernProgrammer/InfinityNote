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
    var user: User?
    let imageName = "profileImage.png"
    let cornerRadius:CGFloat = 160
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = paletteSystemWhite
        setupProfileUI()
    }
}

extension ProfileController {
    func setUserInfo() {
        guard let userInfo = UserInfo.shared.user else { return }
        
        let attributedText = NSMutableAttributedString(string: "\(userInfo.fullname)\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
        attributedText.append(NSMutableAttributedString(string:  userInfo.email, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .light), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue]))
        self.userInfoLabel.attributedText = attributedText

    }
    
    fileprivate func setupMainStackView() {
        let stackView = UIStackView(arrangedSubviews: [profileImageContainer, profileBodyContainer])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
    fileprivate func setupProfileImage() {
        let userInfo = UserInfo.shared.user
        
        if userInfo?.profileImageUID != "" {
            print("Yes")
            
            let proImage = getImagefromUID(uid: userInfo!.profileImageUID)
//
            profileImageContainer.addSubview(profileImage)
            profileImage.anchor(topAnchor: profileImageContainer.topAnchor, bottomAnchor: profileImageContainer.bottomAnchor, leadingAnchor: profileImageContainer.leadingAnchor, trailingAnchor: profileImageContainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
            profileImage.contentHorizontalAlignment = .center
            profileImage.contentVerticalAlignment = .center
            profileImage.imageView?.contentMode = .scaleAspectFill
            profileImage.imageView?.layer.cornerRadius = cornerRadius
//
//
        } else {
            print("No")
            profileImageContainer.addSubview(profileImageView)
            profileImageView.anchor(topAnchor: profileImageContainer.topAnchor, bottomAnchor: profileImageContainer.bottomAnchor, leadingAnchor: profileImageContainer.leadingAnchor, trailingAnchor: profileImageContainer.trailingAnchor, paddingTop: 30, paddingBottom: 30, paddingLeft: 30, paddingRight: 30, width: 0, height: 0)
            profileImageView.addSubview(profileImageButton)
            profileImageButton.anchor(topAnchor: profileImageView.topAnchor, bottomAnchor: profileImageView.bottomAnchor, leadingAnchor: profileImageView.leadingAnchor, trailingAnchor: profileImageView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        }
      
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
        let userInfo = UserInfo.shared.user
        let name = userInfo?.fullname
        let email = userInfo?.email
        let dictionaryValues = ["fullname": name, "email": email, "profileImageUID": imageName]
        let values = [uid:dictionaryValues]
        Database.database().reference().child(uid).child("user").updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Oops, looks like something went wrong: ", error)
                return
            }
            print("Successful Upload")
        }
    }
    
    fileprivate func getImagefromUID(uid: String) {
        let storageRef = Storage.storage().reference()
        let userInfo = UserInfo.shared.user
        let imageRef = storageRef.child(userInfo!.uid).child(uid)
        
        imageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                self.profileImage.setImage(image, for: .normal)
            }
        }
    }
    
    func setSelectImage(image: UIImage) {
        // Upload to Firebase
//        let imageName = NSUUID().uuidString
        let uid = String(Auth.auth().currentUser!.uid)
        guard let data = image.pngData() else { return }
        let storageRef = Storage.storage().reference().child(uid).child(imageName)
        storageRef.putData(data, metadata: nil) { (meta, error) in
            if error != nil {
                print(error as Any)
                return
            }
            self.updateUser(uid: uid, imageName: self.imageName)
            // Set image as profile Pic
            self.profileImageView.removeFromSuperview()
            self.profileImageContainer.addSubview(self.profileImage)
            self.profileImage.anchor(topAnchor: self.profileImageContainer.topAnchor, bottomAnchor: self.profileImageContainer.bottomAnchor, leadingAnchor: self.profileImageContainer.leadingAnchor, trailingAnchor: self.profileImageContainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
            self.profileImage.setImage(image, for: .normal)
            self.profileImage.contentHorizontalAlignment = .center
            self.profileImage.contentVerticalAlignment = .center
            self.profileImage.imageView?.contentMode = .scaleAspectFill
            self.profileImage.imageView?.layer.cornerRadius = self.cornerRadius
            
            print("Update User")
        }
        
       
    }
}

