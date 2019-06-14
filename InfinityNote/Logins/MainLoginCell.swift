//
//  MainLoginCell.swift
//  InfinityNote
//
//  Created by Diego Bustamante on 6/14/19.
//  Copyright © 2019 Diego Bustamante. All rights reserved.
//

import UIKit
import Lottie

class MainLoginCell: UICollectionViewCell {
    var loginSignUpDelegate : LoginSignUpDelegate?
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        let attributedText = NSMutableAttributedString(string: "Login", attributes: [NSAttributedString.Key.foregroundColor: paletteSystemWhite, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = paletteSystemWhite.cgColor
        return button
    }()
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = paletteSystemGreen
        let attributedText = NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.foregroundColor: paletteSystemWhite, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 20
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
        let stackView = UIStackView(arrangedSubviews:[loginButton, signUpButton])
        
        addSubview(stackView)
        stackView.anchor(topAnchor: nil, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, paddingTop: 20, paddingBottom: 20, paddingLeft: 20, paddingRight: 20, width: 0, height: 44)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
    }
    
    @objc func handleLogin() {
        let indexPath = IndexPath(item: 1, section: 0)
        loginSignUpDelegate?.scrollCollectionView(indexPath: indexPath)
    }
    
    @objc func handleSignup() {
        let indexPath = IndexPath(item: 2, section: 0)
        loginSignUpDelegate?.scrollCollectionView(indexPath: indexPath)
    }
}


