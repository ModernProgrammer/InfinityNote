//
//  LoginController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/12/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Lottie
import Firebase

protocol LoginSignUpDelegate {
    func scrollCollectionView(indexPath: IndexPath)
    func handleLoginPress(email: String, password: String)
    func handleSignupPress(fullname: String, email: String, password: String)
}

class LoginController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LoginSignUpDelegate {
    
    let cellId = "cellId"
    lazy var collectionView : UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowlayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let loginTitle : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Welcome", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32),NSAttributedString.Key.foregroundColor: paletteSystemWhite])
        attributedText.append( NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11),NSAttributedString.Key.foregroundColor: paletteSystemWhite]))
        attributedText.append( NSMutableAttributedString(string: "Login or Sign Up to Continue", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .light),NSAttributedString.Key.foregroundColor: paletteSystemWhite]))
        label.attributedText = attributedText
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let logoImageLottie: UIImageView = {
        let view = UIImageView(image: UIImage(named:  "infinityLogo"))
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar(barTintColor: paletteSystemGreen, tintColor: paletteSystemWhite, textColor: paletteSystemWhite, clearNavBar: true)
        setupUserInterface()
        setupKeyboardDismissal()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard)))
        
    }
}

// MARK: -UI/UX Functions
extension LoginController {
    func setGradientBackground() {
        let colorTop =  paletteSystemGreen.cgColor
        let colorBottom = paletteSystemBlue.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func setupUserInterface(){
        setGradientBackground()
        view.backgroundColor = paletteSystemWhite
        view.addSubview(logoImageLottie)
        logoImageLottie.alpha = 0.1
        logoImageLottie.anchor(topAnchor: view.topAnchor, bottomAnchor: view.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
        let stackView = UIStackView(arrangedSubviews: [loginTitle])
        view.addSubview(stackView)
    
        view.addSubview(collectionView)
        collectionView.anchor(topAnchor: nil, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 20, paddingBottom: 20, paddingLeft: 0, paddingRight: 0, width: 0, height: view.frame.height/2)
        
        stackView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: collectionView.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
    }
}
// MARK: -Button CollectionView Delegate Functions
extension LoginController {
    func scrollCollectionView(indexPath: IndexPath) {
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
        
    }
}

// MARK: -Login Delegate Functions
extension LoginController {
    func handleLoginPress(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Oops, looks like something went wrong: ", error)
                return
            }
            print("Successful logging in")
            guard let viewController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            viewController.setUpControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: -Signup Delegate Functions
extension LoginController {
    func handleSignupPress(fullname: String, email: String, password: String){
        print("Handle Signup")
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print("Oops, looks like something went wrong: ", err)
                return
            }
            
            print("Successfully created user with userId: ", user?.user.uid ?? "")
            
            guard let uid = user?.user.uid else { return }
            let dictionaryValues = ["fullname":fullname, "email":email]
            let values = [uid:dictionaryValues]
            Database.database().reference().child(uid).child("user").updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print("Oops, looks like something went wrong: ", error)
                    return
                }
                print("Successful")
                guard let viewController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                viewController.setUpControllers()
                
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
}

// MARK: Keyboard Functions
extension LoginController {
    @objc func handleDismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func handleDone() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let height = keyboardSize.size.height/2
            self.view.transform = CGAffineTransform(translationX: 0, y: -height)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.transform = .identity
    }
    
    func setupKeyboardDismissal() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleDismiss() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: -UICollectionView Functions
extension LoginController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            collectionView.register(MainLoginCell.self, forCellWithReuseIdentifier: cellId)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MainLoginCell
            cell.loginSignUpDelegate = self
            return cell
        case 1:
            collectionView.register(LoginCell.self, forCellWithReuseIdentifier: cellId)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LoginCell
            cell.loginSignUpDelegate = self

            return cell
        case 2:
            collectionView.register(SignUpCell.self, forCellWithReuseIdentifier: cellId)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SignUpCell
            cell.loginSignUpDelegate = self
            return cell
  
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = view.frame.height/2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

