//
//  LoginCell.swift
//  InfinityNote
//
//  Created by Diego Bustamante on 6/14/19.
//  Copyright © 2019 Diego Bustamante. All rights reserved.
//

import UIKit
class LoginCell: UICollectionViewCell {
    var loginSignUpDelegate : LoginSignUpDelegate?
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
        let attributedText = NSMutableAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.3), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
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
        let attributedText = NSMutableAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.3), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        tf.attributedPlaceholder = attributedText
        tf.textColor = paletteSystemWhite
        tf.font = UIFont.boldSystemFont(ofSize: 24)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = paletteSystemGreen
        let attributedText = NSMutableAttributedString(string: "Login", attributes: [NSAttributedString.Key.foregroundColor: paletteSystemWhite, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Don't have an account?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 10)]))
        attributedText.append(NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.foregroundColor: paletteSystemGreen, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 2
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        button.titleLabel?.textAlignment = NSTextAlignment.center
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .clear
        let stackView = UIStackView(arrangedSubviews: [emailTextField, emailtextFieldLineSeparator,passwordTextField,passwordtextFieldLineSeparator,loginButton,signupButton])
        addSubview(stackView)
        stackView.anchor(topAnchor: topAnchor, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, paddingTop: 20, paddingBottom: 20, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        
        loginButton.addTarget(self, action: #selector(handleLoginPress), for: .touchUpInside)
        
        signupButton.addTarget(self, action: #selector(handleSignUpPress), for: .touchUpInside)

    }
}

extension LoginCell {
    @objc func handleLoginPress(){
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        // Delegate to LoginController
        loginSignUpDelegate?.handleLoginPress(email: email, password: password)
    }
    

    @objc func handleSignUpPress(){
        let indexPath = IndexPath(item: 2, section: 0)
        loginSignUpDelegate?.scrollCollectionView(indexPath: indexPath)
    }
}
