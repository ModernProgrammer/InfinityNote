//
//  SignUpCell.swift
//  InfinityNote
//
//  Created by Diego Bustamante on 6/14/19.
//  Copyright © 2019 Diego Bustamante. All rights reserved.
//

import UIKit

class SignUpCell: UICollectionViewCell {
    var loginSignUpDelegate : LoginSignUpDelegate?
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
        let attributedText = NSMutableAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.3), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)])
        tf.attributedPlaceholder = attributedText
        tf.textColor = paletteSystemWhite
        tf.font = UIFont.boldSystemFont(ofSize: 24)
        return tf
    }()
    
    let fullnametextFieldLineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        let attributedText = NSMutableAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.3), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)])
        tf.attributedPlaceholder = attributedText
        tf.textColor = paletteSystemWhite
        tf.font = UIFont.boldSystemFont(ofSize: 24)
        return tf
    }()
    
    let emailtextFieldLineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    let passwordtextFieldLineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        let attributedText = NSMutableAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.3), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)])
        tf.attributedPlaceholder = attributedText
        tf.textColor = paletteSystemWhite
        tf.font = UIFont.boldSystemFont(ofSize: 24)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = paletteSystemGreen
        let attributedText = NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.foregroundColor: paletteSystemWhite, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Already have an account?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 10)]))
        attributedText.append(NSMutableAttributedString(string: "Login", attributes: [NSAttributedString.Key.foregroundColor: paletteSystemGreen, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 2
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        button.titleLabel?.textAlignment = NSTextAlignment.center
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
}

// MARK: -UI/UX Functions
extension SignUpCell {
    func setupUserInterface(){
        let stackView = UIStackView(arrangedSubviews:[fullnameTextField,fullnametextFieldLineSeparator,emailTextField,emailtextFieldLineSeparator,passwordTextField,passwordtextFieldLineSeparator,signupButton,loginButton])
        
        addSubview(stackView)
        stackView.anchor(topAnchor: topAnchor, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, paddingTop: 20, paddingBottom: 20, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        
        signupButton.addTarget(self, action: #selector(handleSignupPress), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(handleLoginPress), for: .touchUpInside)
    }
}

// MARK: -Button Functions
extension SignUpCell {
    @objc func handleSignupPress(){
        guard let fullName = fullnameTextField.text , fullName.count > 0 else { return }
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        loginSignUpDelegate?.handleSignupPress(fullname: fullName, email: email, password: password)
    }
    
    @objc func handleLoginPress(){
        let indexPath = IndexPath(row: 1, section: 0)
        loginSignUpDelegate?.scrollCollectionView(indexPath: indexPath)
    }
}

