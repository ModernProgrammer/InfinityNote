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

class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupUserInterface()
        AppUtility.lockOrientation(.portrait)
        
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
    
    let logoTitleImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "LoginLogo")
        image.contentMode = .scaleAspectFit
        image.tintColor = paletteSystemWhite
        image.image?.withRenderingMode(.alwaysOriginal)
        return image
    }()
    
    let logoImageLottie: LOTAnimationView = {
        let image = LOTAnimationView(name: "animation-w800-h600")
        image.play()
        image.loopAnimation = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.layer.cornerRadius = 5
        return view
    }()
    
    let emailtextFieldLineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor.init(white: 1, alpha: 0.3)
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        let attributedText = NSMutableAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.3), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
        tf.attributedPlaceholder = attributedText
        tf.textColor = paletteSystemWhite
        tf.font = UIFont.boldSystemFont(ofSize: 24)
        
        return tf
    }()
    
    let passwordtextFieldLineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor.init(white: 1, alpha: 0.3)
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        let attributedText = NSMutableAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.3), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
        tf.attributedPlaceholder = attributedText
        tf.textColor = paletteSystemWhite
        tf.font = UIFont.boldSystemFont(ofSize: 24)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = paletteSystemGreen
        let attributedText = NSMutableAttributedString(string: "Login", attributes: [NSAttributedStringKey.foregroundColor: paletteSystemWhite, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleLoginPress), for: .touchUpInside)
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Don't have an account?", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 10)]))
        attributedText.append(NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGreen, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 2
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.addTarget(self, action: #selector(handleSignUpPress), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLoginPress(){
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
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

    @objc func handleForgotPaswordPress(){
        print("Handle Password")
        let signupView = SignupController()
        navigationController?.pushViewController(signupView, animated: true)
    }
    
    @objc func handleSignUpPress(){
        print("Handle Sign Up")
        let signupView = SignupController()
        navigationController?.pushViewController(signupView, animated: true)
    }
    
    func setupUserInterface(){
        view.addSubview(backgroundImage)
        view.addSubview(textFieldContainer)
        backgroundImage.anchor(topAnchor: view.topAnchor, bottomAnchor: view.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        textFieldContainer.anchor(topAnchor: nil, bottomAnchor: view.bottomAnchor, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 30, paddingRight: 30, width: 0, height: 0)
        textFieldContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3).isActive = true

        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton, signupButton])
        view.addSubview(stackView)
        stackView.anchor(topAnchor: textFieldContainer.topAnchor, bottomAnchor: nil, leadingAnchor: textFieldContainer.leadingAnchor, trailingAnchor: textFieldContainer.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        
        view.addSubview(logoTitleImage)

        logoTitleImage.anchor(topAnchor: nil, bottomAnchor: textFieldContainer.topAnchor, leadingAnchor: textFieldContainer.leadingAnchor, trailingAnchor: textFieldContainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 200)
        
        view.addSubview(emailtextFieldLineSeparator)
        emailtextFieldLineSeparator.anchor(topAnchor: nil, bottomAnchor: emailTextField.bottomAnchor, leadingAnchor: emailTextField.leadingAnchor, trailingAnchor: emailTextField.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
        view.addSubview(passwordtextFieldLineSeparator)
        passwordtextFieldLineSeparator.anchor(topAnchor: nil, bottomAnchor: passwordTextField.bottomAnchor, leadingAnchor: passwordTextField.leadingAnchor, trailingAnchor: passwordTextField.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
        
    }
}
