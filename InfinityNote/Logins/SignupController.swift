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
        setupUserInterface()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Background")
        image.contentMode = .scaleToFill
        return image
    }()
    
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "SignupLogo")
        image.contentMode = .scaleAspectFit
        image.tintColor = paletteSystemWhite
        image.image?.withRenderingMode(.alwaysOriginal)
        return image
    }()
    
    let textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.layer.cornerRadius = 5
        return view
    }()
    
    let fullnameTextField: UITextField = {
        let tf = UITextField()
        let attributedText = NSMutableAttributedString(string: "Full Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.3), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24)])
        tf.attributedPlaceholder = attributedText
        tf.textColor = paletteSystemWhite
        tf.font = UIFont.boldSystemFont(ofSize: 24)
        return tf
    }()
    
    let usernametextFieldLineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        let attributedText = NSMutableAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.3), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24)])
        tf.attributedPlaceholder = attributedText
        tf.textColor = paletteSystemWhite
        tf.font = UIFont.boldSystemFont(ofSize: 24)
        return tf
    }()
    
    let emailtextFieldLineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    let passwordtextFieldLineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        let attributedText = NSMutableAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.3), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24)])
        tf.attributedPlaceholder = attributedText
        tf.textColor = paletteSystemWhite
        tf.font = UIFont.boldSystemFont(ofSize: 24)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = paletteSystemGreen
        let attributedText = NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.foregroundColor: paletteSystemWhite, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleSignupPress), for: .touchUpInside)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Already have an account?", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 10)]))
        attributedText.append(NSMutableAttributedString(string: "Login", attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGreen, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 2
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.addTarget(self, action: #selector(handleLoginPress), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSignupPress(){
        print("Handle Signup")
        guard let fullName = fullnameTextField.text , fullName.count > 0 else { return }
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print("Oops, looks like something went wrong: ", err)
                return
            }
            
            print("Successfully created user with userId: ", user?.uid ?? "")
            
            guard let uid = user?.uid else { return }
            let dictionaryValues = ["fullname":fullName, "email":email]
            let values = [uid:dictionaryValues]
            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
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
    
    @objc func handleLoginPress(){
        print("Handle Login")
        navigationController?.popViewController(animated: true)
    }
    
    func setupUserInterface(){
        view.addSubview(backgroundImage)
        view.addSubview(textFieldContainer)
        backgroundImage.anchor(topAnchor: view.topAnchor, bottomAnchor: view.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        
        textFieldContainer.anchor(topAnchor: nil, bottomAnchor: view.bottomAnchor, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 30, paddingRight: 30, width: 0, height: 0)
        textFieldContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3).isActive = true
        
        let stackView = UIStackView(arrangedSubviews:[fullnameTextField,emailTextField,passwordTextField,signupButton,loginButton])
        
        view.addSubview(stackView)
        stackView.anchor(topAnchor: textFieldContainer.topAnchor, bottomAnchor: nil, leadingAnchor: textFieldContainer.leadingAnchor, trailingAnchor: textFieldContainer.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        
        
        view.addSubview(logoImage)
        logoImage.anchor(topAnchor: nil, bottomAnchor: textFieldContainer.topAnchor, leadingAnchor: textFieldContainer.leadingAnchor, trailingAnchor: textFieldContainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 200)
        
        view.addSubview(usernametextFieldLineSeparator)
        view.addSubview(emailtextFieldLineSeparator)
        view.addSubview(passwordtextFieldLineSeparator)
        
        usernametextFieldLineSeparator.anchor(topAnchor: nil, bottomAnchor: fullnameTextField.bottomAnchor, leadingAnchor: fullnameTextField.leadingAnchor, trailingAnchor: fullnameTextField.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
        emailtextFieldLineSeparator.anchor(topAnchor: nil, bottomAnchor: emailTextField.bottomAnchor, leadingAnchor: emailTextField.leadingAnchor, trailingAnchor: emailTextField.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
        passwordtextFieldLineSeparator.anchor(topAnchor: nil, bottomAnchor: passwordTextField.bottomAnchor, leadingAnchor: passwordTextField.leadingAnchor, trailingAnchor: passwordTextField.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
}
